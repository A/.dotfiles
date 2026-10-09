"""notif-center UI server: the notification history the recorder writes, plus
swaync's do-not-disturb switch.

Built on the shared webview server (~/.config/waybar/webview/httpd.py), which
owns the 127.0.0.1 binding, the per-process token, the Host check, static files
and CSP. Actions take log line numbers or entry ids, never URLs or paths: the
server looks the entry up itself and only ever xdg-opens http(s) links.

Dismissing hides entries (notiflog's dismissed.json) and closes the ones the
notification daemon still shows: CloseNotification goes to the unique bus name
the recorder saw answer the Notify, so after a daemon restart it reaches nobody
rather than a different notification that reuses the id.

Stdlib only.
"""

import html
import re
import shutil
import subprocess
import sys
import threading
from collections import Counter
from http import HTTPStatus
from pathlib import Path
from urllib.parse import unquote

HERE = Path(__file__).resolve().parent
# configs/swaync/notif-center -> configs/waybar/webview
sys.path.insert(0, str(HERE.parent.parent / "waybar" / "webview"))

import icons  # noqa: E402
import notiflog  # noqa: E402
from httpd import IMAGE_TYPES, ApiError, Image, int_arg, is_web_url, make_server, mtime_ns, open_url, spawn  # noqa: E402

STATIC_DIR = HERE / "static"
PAGES = ("log",)
LOG_PAGE = 500
LOG_PAGE_MAX = 5000

URL_RE = re.compile(r"https?://[^\s<>\"']+")
TAG_RE = re.compile(r"<[^>]*>")


def plain(text):
    """Notification bodies may carry markup; show and copy them as text."""
    return html.unescape(TAG_RE.sub("", text or ""))


def entry_by_number(number):
    for n, entry in notiflog.read():
        if n == number:
            return entry
    raise ApiError(HTTPStatus.NOT_FOUND, "Запись не найдена")


def image_file(value):
    """An absolute image path (or file:// URI) that exists, else None."""
    if value.startswith("file://"):
        value = unquote(value[7:])
    if not value.startswith("/"):
        return None
    path = Path(value)
    if path.suffix.lower() not in IMAGE_TYPES or not path.is_file():
        return None
    return path


def icon_file(entry):
    """The entry's own image, else its app icon from the icon theme, else its .desktop file's icon."""
    names = []
    for value in (entry.get("image_path"), entry.get("icon"), entry.get("app_icon")):
        if isinstance(value, str) and value:
            path = image_file(value)
            if path:
                return path
            names.append(value)
    desktop = icons.desktop_icon(entry.get("desktop_entry") or "")
    if desktop:
        path = image_file(desktop)
        if path:
            return path
        names.append(desktop)
    app = (entry.get("app") or "").strip().lower()
    if app:
        names += [app, app.replace(" ", "-")]
    for name in names:
        path = icons.lookup(name)
        if path:
            return path
    return None


def entry_url(entry):
    url = entry.get("url") or ""
    if not url:
        match = URL_RE.search(entry.get("body") or "") or URL_RE.search(entry.get("summary") or "")
        url = html.unescape(match.group(0)) if match else ""
    return url if is_web_url(url) else ""


def entry_json(number, entry):
    return {
        "n": number,
        "id": entry["id"],
        "time": entry.get("time") or 0,
        "app": entry.get("app") or "",
        "summary": plain(entry.get("summary")),
        "body": plain(entry.get("body")),
        "critical": str(entry.get("urgency")).lower() in ("2", "critical"),
        "url": entry_url(entry),
    }


def matches(entry, app, needle):
    if app and entry["app"] != app:
        return False
    return not needle or needle in f"{entry['app']}\n{entry['summary']}\n{entry['body']}".casefold()


def ids_arg(value):
    if not isinstance(value, list) or not all(isinstance(i, str) for i in value):
        raise ApiError(HTTPStatus.BAD_REQUEST, "'ids' must be a list of strings")
    return value


def close_targets(rows, ids):
    """(daemon bus, daemon id) of the dismissed entries that are still the newest Notify for that
    pair: an older entry whose popup was since replaced must not close its replacement."""
    newest = {}
    for _, entry in rows:
        bus, daemon_id = entry.get("daemon_bus"), entry.get("daemon_id")
        if isinstance(bus, str) and bus and isinstance(daemon_id, int) and daemon_id > 0:
            newest[(bus, daemon_id)] = entry["id"]
    return [key for key, entry_id in newest.items() if entry_id in ids]


def close_in_daemon(targets):
    """Best effort and off the request thread: an already-closed notification just errors."""
    if not targets or not shutil.which("gdbus"):
        return

    def run():
        for bus, daemon_id in targets:
            try:
                subprocess.run(
                    [
                        "gdbus", "call", "--session", "--dest", bus,
                        "--object-path", "/org/freedesktop/Notifications",
                        "--method", "org.freedesktop.Notifications.CloseNotification", str(daemon_id),
                    ],
                    stdin=subprocess.DEVNULL,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                    timeout=3,
                    check=False,
                )
            except (OSError, subprocess.TimeoutExpired):
                pass

    threading.Thread(target=run, daemon=True).start()


def swaync_dnd(flag):
    """swaync's do-not-disturb state after running `swaync-client <flag>`; None if swaync is unreachable."""
    if not shutil.which("swaync-client"):
        return None
    try:
        result = subprocess.run(
            ["swaync-client", flag],
            stdin=subprocess.DEVNULL,
            capture_output=True,
            text=True,
            timeout=3,
            check=False,
        )
    except (OSError, subprocess.TimeoutExpired):
        return None
    state = result.stdout.strip().lower()
    if result.returncode != 0 or state not in ("true", "false"):
        return None
    return state == "true"


class Api:
    def get(self, path, query):
        if path == "/api/stamp":
            return {"log": mtime_ns(notiflog.LOG_PATH) + mtime_ns(notiflog.DISMISSED_PATH)}
        if path == "/api/log":
            return self._log(query)
        if path == "/api/dnd":
            return {"dnd": swaync_dnd("--get-dnd")}
        if m := re.fullmatch(r"/api/log/(\d+)/icon", path):
            try:
                return Image(icon_file(entry_by_number(int(m.group(1)))))
            except ApiError:
                return Image(None)
        raise ApiError(HTTPStatus.NOT_FOUND, "Not found")

    def post(self, path, body):
        if path == "/api/log/open":
            entry = entry_by_number(int_arg(body.get("n"), "n"))
            url = entry_url(entry)
            if url:
                open_url(url)
                return {"action": "open"}
            text = plain(entry.get("body")) or plain(entry.get("summary"))
            if not shutil.which("wl-copy"):
                raise ApiError(HTTPStatus.CONFLICT, "wl-copy не найден")
            spawn(["wl-copy"], text)
            return {"action": "copy"}
        if path == "/api/log/dismiss":
            entry_id = body.get("id")
            if not isinstance(entry_id, str) or not entry_id:
                raise ApiError(HTTPStatus.BAD_REQUEST, "'id' must be a string")
            return self._dismiss(lambda entry: entry["id"] == entry_id)
        if path == "/api/log/dismiss-all":
            app = body.get("app") or ""
            needle = (body.get("q") or "").casefold().strip()
            if not isinstance(app, str) or not isinstance(needle, str):
                raise ApiError(HTTPStatus.BAD_REQUEST, "'app' and 'q' must be strings")
            return self._dismiss(lambda entry: matches(entry, app, needle))
        if path == "/api/log/undo":
            ids = body.get("ids")
            return {"ids": notiflog.undo(None if ids is None else ids_arg(ids))}
        if path == "/api/log/clear":
            notiflog.clear()
            return {"ok": True}
        if path == "/api/dnd":
            on = body.get("on")
            if not isinstance(on, bool):
                raise ApiError(HTTPStatus.BAD_REQUEST, "'on' must be a boolean")
            dnd = swaync_dnd("--dnd-on" if on else "--dnd-off")
            if dnd is None:
                raise ApiError(HTTPStatus.SERVICE_UNAVAILABLE, "swaync-client недоступен")
            return {"dnd": dnd}
        raise ApiError(HTTPStatus.NOT_FOUND, "Not found")

    def _dismiss(self, select):
        rows = notiflog.read()
        dismissed = notiflog.dismissed_ids()
        ids = [
            entry["id"]
            for entry in (entry_json(n, raw) for n, raw in rows)
            if entry["id"] not in dismissed and select(entry)
        ]
        new = notiflog.dismiss(ids)
        close_in_daemon(close_targets(rows, set(new)))
        return {"ids": new}

    def _log(self, query):
        rows = list(reversed(notiflog.read()))
        dismissed = notiflog.dismissed_ids()
        everything = [entry_json(n, entry) for n, entry in rows]
        for entry in everything:
            entry["dismissed"] = entry["id"] in dismissed
        active = sum(not entry["dismissed"] for entry in everything)
        show_dismissed = query.get("dismissed", [""])[0] == "1"
        entries = everything if show_dismissed else [entry for entry in everything if not entry["dismissed"]]
        apps = Counter(entry["app"] for entry in entries if entry["app"])
        all_count = len(entries)
        app = query.get("app", [""])[0]
        needle = query.get("q", [""])[0].casefold().strip()
        entries = [entry for entry in entries if matches(entry, app, needle)]
        offset = max(0, int_arg(query.get("offset", ["0"])[0], "offset"))
        limit = max(1, min(int_arg(query.get("limit", [str(LOG_PAGE)])[0], "limit"), LOG_PAGE_MAX))
        page = entries[offset : offset + limit]
        by_number = dict(rows)
        for entry in page:
            entry["icon"] = icon_file(by_number[entry["n"]]) is not None
        return {
            "entries": page,
            "total": len(entries),
            "all": all_count,
            "apps": apps.most_common(),
            "active": active,
            "dismissed": len(everything) - active,
            "stored": len(everything),
        }


def make_log_server(port=0):
    return make_server("notif-center", Api(), STATIC_DIR, PAGES, port=port)
