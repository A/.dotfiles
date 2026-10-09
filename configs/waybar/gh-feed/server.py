"""gh-feed UI server: the GitHub feed from gh-feed's state.json, avatars from its cache.

Built on the shared webview server (../webview/httpd.py), which owns the
127.0.0.1 binding, the per-process token, the Host check, static files and CSP.
Actions take ids, never URLs or paths: the server looks the target up itself.

Stdlib only.
"""

import hashlib
import re
import sys
from collections.abc import Callable
from dataclasses import dataclass
from http import HTTPStatus
from pathlib import Path
from typing import Any

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "webview"))

from httpd import ApiError, Image, is_web_url, make_server, mtime_ns, open_url  # noqa: E402

STATIC_DIR = Path(__file__).parent / "static"
PAGES = ("github",)

# gh-notify feed titles: "<emoji> <actor> <verb> — <owner/repo>#<n>"
TITLE_RE = re.compile(r"^(\S+)\s+(.+?)\s+—\s+(\S+)$")
KIND_BY_EMOJI = {
    "👀": "review",
    "✅": "review",
    "❌": "review",
    "📣": "mention",
    "👥": "mention",
    "📌": "mention",
    "💬": "comment",
    "🔄": "status",
}
KIND_BY_REASON = {
    "review_requested": "review",
    "mention": "mention",
    "team_mention": "mention",
    "assign": "mention",
    "comment": "comment",
    "author": "comment",
    "state_change": "status",
}


@dataclass
class Feed:
    """What the server needs from the gh-feed script, which owns the state file."""

    state_path: Path
    avatar_dir: Path
    load_state: Callable[[], dict[str, Any]]
    mark_read: Callable[[str], None]
    mark_all_read: Callable[[], None]


def avatar_key(url):
    return hashlib.sha1(url.encode()).hexdigest() if url else None


def github_item(item, avatar_dir):
    title = item.get("title") or ""
    match = TITLE_RE.match(title)
    emoji, who_verb, ref = match.groups() if match else ("", title, "")
    actor, _, verb = who_verb.partition(" ")
    lines = [line.strip() for line in (item.get("message") or "").splitlines() if line.strip()]
    snippet = " ".join(lines[1:])
    if snippet.startswith("«") and snippet.endswith("»"):
        snippet = snippet[1:-1]
    emoji = emoji.replace("️", "")
    kind = KIND_BY_EMOJI.get(emoji)
    if kind == "comment" and "ревью" in verb:
        kind = "review"
    tags = item.get("tags") or []
    if kind is None and tags:
        kind = KIND_BY_REASON.get(tags[0])
    key = avatar_key(item.get("icon"))
    return {
        "id": item["id"],
        "time": item.get("time") or 0,
        "read": bool(item.get("read")),
        "emoji": emoji if match else "",
        "actor": actor if match else "",
        "verb": verb if match else title,
        "ref": ref,
        "repo": ref.split("#", 1)[0],
        "subject": lines[0] if lines else "",
        "snippet": snippet,
        "kind": kind or "other",
        "click": item.get("click") or "",
        "avatar": key if key and (avatar_dir / f"{key}.png").is_file() else None,
    }


class Api:
    def __init__(self, feed):
        self.feed = feed

    def get(self, path, query):
        del query
        if path == "/api/stamp":
            return {"github": mtime_ns(self.feed.state_path)}
        if path == "/api/github":
            items = [github_item(item, self.feed.avatar_dir) for item in self.feed.load_state()["items"]]
            return {"items": items, "unread": sum(not item["read"] for item in items)}
        if m := re.fullmatch(r"/api/avatar/([0-9a-f]{40})", path):
            path = self.feed.avatar_dir / f"{m.group(1)}.png"
            return Image(path if path.is_file() else None)
        raise ApiError(HTTPStatus.NOT_FOUND, "Not found")

    def post(self, path, body):
        if path == "/api/github/open":
            item = self._github_item(body.get("id"))
            if is_web_url(item.get("click")):
                open_url(item["click"])
            self.feed.mark_read(item["id"])
            return {"ok": True}
        if path == "/api/github/read":
            self.feed.mark_read(self._github_item(body.get("id"))["id"])
            return {"ok": True}
        if path == "/api/github/read-all":
            self.feed.mark_all_read()
            return {"ok": True}
        raise ApiError(HTTPStatus.NOT_FOUND, "Not found")

    def _github_item(self, item_id):
        if not isinstance(item_id, str) or not item_id:
            raise ApiError(HTTPStatus.BAD_REQUEST, "'id' is required")
        for item in self.feed.load_state()["items"]:
            if item["id"] == item_id:
                return item
        raise ApiError(HTTPStatus.NOT_FOUND, "Уведомление не найдено")


def make_feed_server(feed, port=0):
    return make_server("gh-feed", Api(feed), STATIC_DIR, PAGES, port=port)
