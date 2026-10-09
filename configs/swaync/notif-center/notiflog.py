"""The notification history file, shared by notif-center's recorder and server.

Log: $XDG_DATA_HOME/notif-log/log.jsonl, one JSON object per Notify call, never
trimmed. It keeps every notification body forever (chat messages, one-time
codes), so the directory is 0700 and the file 0600. Writers and the clear
action take log.lock; readers don't need it, since appends are whole lines.

Noise (volume/brightness OSDs, empty or transient notifications, apps listed in
./ignore-apps) is never recorded; `prune` drops it from an existing log.
Dismissing an entry doesn't touch the log: dismissed ids live in dismissed.json
next to it, written under the same lock.

Stdlib only.
"""

import fcntl
import hashlib
import json
import os
from contextlib import contextmanager
from pathlib import Path

DATA_DIR = Path(os.environ.get("XDG_DATA_HOME") or Path.home() / ".local" / "share") / "notif-log"
LOG_PATH = DATA_DIR / "log.jsonl"
LOCK_PATH = DATA_DIR / "log.lock"
DISMISSED_PATH = DATA_DIR / "dismissed.json"
IGNORE_PATH = Path(__file__).resolve().parent / "ignore-apps"
OSD_HINTS = ("value", "x-canonical-private-synchronous", "synchronous")
UNDO_DEPTH = 20


@contextmanager
def locked():
    DATA_DIR.mkdir(mode=0o700, parents=True, exist_ok=True)
    fd = os.open(LOCK_PATH, os.O_RDWR | os.O_CREAT, 0o600)
    with open(fd, "r+") as lock_file:
        fcntl.flock(lock_file.fileno(), fcntl.LOCK_EX)
        try:
            yield
        finally:
            fcntl.flock(lock_file.fileno(), fcntl.LOCK_UN)


def append(entry):
    line = json.dumps(entry, ensure_ascii=False) + "\n"
    with locked():
        fd = os.open(LOG_PATH, os.O_WRONLY | os.O_APPEND | os.O_CREAT, 0o600)
        with open(fd, "a", encoding="utf-8") as handle:
            handle.write(line)


def ignored_apps():
    """Lower-cased app names from ignore-apps, re-read on every call so edits apply live."""
    try:
        lines = IGNORE_PATH.read_text(encoding="utf-8").splitlines()
    except OSError:
        return set()
    return {line.split("#", 1)[0].strip().casefold() for line in lines} - {""}


def is_noise(entry, hints):
    if not (entry.get("summary") or "").strip() and not (entry.get("body") or "").strip():
        return True
    if hints.get("transient") or any(key in hints for key in OSD_HINTS):
        return True
    return (entry.get("app") or "").strip().casefold() in ignored_apps()


def line_id(line):
    """Stable id for entries recorded before ids existed: the raw line survives prune unchanged."""
    return "l" + hashlib.sha1(line.rstrip("\n").encode("utf-8")).hexdigest()[:24]


def parse(line):
    try:
        entry = json.loads(line)
    except ValueError:
        return None
    if not isinstance(entry, dict):
        return None
    if not isinstance(entry.get("id"), str) or not entry["id"]:
        entry["id"] = line_id(line)
    return entry


def read():
    """(line number, entry) for every parseable line, oldest first; every entry has an "id"."""
    entries = []
    try:
        with open(LOG_PATH, encoding="utf-8") as handle:
            for number, line in enumerate(handle):
                entry = parse(line)
                if entry is not None:
                    entries.append((number, entry))
    except OSError:
        pass
    return entries


def write_private(path, text):
    tmp = path.with_name(path.name + ".tmp")
    fd = os.open(tmp, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
    with open(fd, "w", encoding="utf-8") as handle:
        handle.write(text)
    os.replace(tmp, path)


def prune():
    """Rewrite the log without the entries the recorder would now drop; (before, after) entry counts.
    Old entries carry no hints, so only the empty-text and ignore-apps rules apply to them."""
    with locked():
        try:
            lines = LOG_PATH.read_text(encoding="utf-8").splitlines(keepends=True)
        except OSError:
            return 0, 0
        kept = []
        before = 0
        for line in lines:
            entry = parse(line)
            if entry is None:
                kept.append(line)
                continue
            before += 1
            if not is_noise(entry, {}):
                kept.append(line)
        write_private(LOG_PATH, "".join(kept))
    return before, before - (len(lines) - len(kept))


def _load_dismissed():
    try:
        state = json.loads(DISMISSED_PATH.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        state = None
    if not isinstance(state, dict):
        state = {}
    ids = state.get("ids")
    batches = state.get("batches")
    return {
        "ids": [i for i in ids if isinstance(i, str)] if isinstance(ids, list) else [],
        "batches": [b for b in batches if isinstance(b, list)] if isinstance(batches, list) else [],
    }


def dismissed_ids():
    return set(_load_dismissed()["ids"])


def dismiss(ids):
    """Mark ids dismissed as one undoable batch; returns the ids that were newly dismissed."""
    with locked():
        state = _load_dismissed()
        current = set(state["ids"])
        new = [i for i in dict.fromkeys(ids) if i not in current]
        if new:
            state["ids"] += new
            state["batches"] = (state["batches"] + [new])[-UNDO_DEPTH:]
            write_private(DISMISSED_PATH, json.dumps(state))
    return new


def undo(ids=None):
    """Un-dismiss the given ids, or the most recent batch when none are given; returns the restored ids."""
    with locked():
        state = _load_dismissed()
        if ids is None:
            restore = set(state["batches"][-1]) if state["batches"] else set()
        else:
            restore = set(ids) & set(state["ids"])
        if restore:
            state["ids"] = [i for i in state["ids"] if i not in restore]
            state["batches"] = [b for b in ([i for i in b if i not in restore] for b in state["batches"]) if b]
            write_private(DISMISSED_PATH, json.dumps(state))
    return sorted(restore)


def clear():
    with locked():
        if LOG_PATH.exists():
            os.close(os.open(LOG_PATH, os.O_WRONLY | os.O_TRUNC))
        DISMISSED_PATH.unlink(missing_ok=True)
