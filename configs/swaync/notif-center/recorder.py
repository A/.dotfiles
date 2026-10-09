"""notif-center recorder: log every desktop notification from the session bus.

Becomes a D-Bus monitor (org.freedesktop.DBus.Monitoring.BecomeMonitor) for
org.freedesktop.Notifications.Notify method calls and appends each one to the
history (notiflog.py). Watching the bus rather than hooking the notification
daemon means it records whatever daemon runs, and records during do-not-disturb,
which swaync's `scripts` skip. Noise (notiflog.is_noise) is dropped here.

It also watches the daemon's replies: an entry is held until the reply to its
Notify arrives and is written with the daemon's notification id and unique bus
name (`daemon_id`, `daemon_bus`), so dismissing it can close the live popup.
Without a reply within REPLY_TIMEOUT_MS it is written without them. Holding the
write keeps one line per notification, which no reader has to merge.

Needs PyGObject, so it runs on /usr/bin/python3. Exits non-zero when the bus
connection drops, for systemd's Restart=on-failure.
"""

import signal
import sys
import threading
import time
import uuid

import gi

gi.require_version("Gio", "2.0")
from gi.repository import Gio, GLib  # noqa: E402

import notiflog  # noqa: E402

NOTIFICATIONS = "org.freedesktop.Notifications"
MATCH_CALLS = f"type='method_call',interface='{NOTIFICATIONS}',member='Notify'"
# dbus-broker matches a monitor's sender on a well-known name: these are the daemon's replies.
MATCH_REPLIES = f"type='method_return',sender='{NOTIFICATIONS}'"
REPLY_TIMEOUT_MS = 1500
IMAGE_DATA_HINTS = ("image-data", "image_data", "icon_data")


def log(message):
    print(f"notif-center record: {message}", file=sys.stderr, flush=True)


def hints_dict(variant):
    """a{sv} to a dict of plain values; raw pixel hints become True so the log stays text."""
    hints = {}
    for i in range(variant.n_children()):
        entry = variant.get_child_value(i)
        key = entry.get_child_value(0).get_string()
        if key in IMAGE_DATA_HINTS:
            hints[key] = True
            continue
        value = entry.get_child_value(1).get_variant().unpack()
        if isinstance(value, bytes):
            value = value.decode("utf-8", "replace")
        hints[key] = value
    return hints


def text(value):
    return value if isinstance(value, str) else ""


def make_entry(body):
    """(entry, hints) for Notify(app_name s, replaces_id u, app_icon s, summary s, body s, actions as,
    hints a{sv}, expire_timeout i)."""
    app, replaces_id, app_icon, summary, text_body = (body.get_child_value(i).unpack() for i in range(5))
    actions = body.get_child_value(5).unpack()
    hints = hints_dict(body.get_child_value(6))
    expire_timeout = body.get_child_value(7).unpack()
    image_path = text(hints.get("image-path")) or text(hints.get("image_path"))
    urgency = hints.get("urgency")
    entry = {
        "id": uuid.uuid4().hex,
        "time": int(time.time()),
        "app": app,
        "replaces_id": replaces_id,
        "app_icon": app_icon,
        "summary": summary,
        "body": text_body,
        "actions": [[actions[i], actions[i + 1]] for i in range(0, len(actions) - 1, 2)],
        "urgency": urgency if isinstance(urgency, int) else 1,
        "category": text(hints.get("category")),
        "desktop_entry": text(hints.get("desktop-entry")),
        "image_path": image_path,
        "image_data": any(hints.get(key) is True for key in IMAGE_DATA_HINTS),
        "icon": image_path or app_icon,
        "url": text(hints.get("x-notif-log-url")),
        "expire_timeout": expire_timeout,
    }
    return entry, hints


def write(entry):
    try:
        notiflog.append(entry)
    except Exception as exc:
        log(f"record failed: {exc!r}")


class Pending:
    """Entries waiting for the daemon's reply, keyed by (caller, call serial). The bus filter runs
    on GDBus's worker thread while the timeouts fire on the main loop, hence the lock."""

    def __init__(self):
        self.lock = threading.Lock()
        self.entries = {}

    def hold(self, key, entry):
        with self.lock:
            self.entries[key] = entry
        GLib.timeout_add(REPLY_TIMEOUT_MS, self._expire, key)

    def take(self, key):
        with self.lock:
            return self.entries.pop(key, None)

    def _expire(self, key):
        entry = self.take(key)
        if entry is not None:
            write(entry)
        return GLib.SOURCE_REMOVE

    def flush(self):
        with self.lock:
            entries, self.entries = list(self.entries.values()), {}
        for entry in entries:
            write(entry)


PENDING = Pending()


def on_message(connection, message, incoming):
    if not incoming:
        return message
    kind = message.get_message_type()
    if kind == Gio.DBusMessageType.METHOD_RETURN:
        if message.get_destination() == connection.get_unique_name():
            return message  # BecomeMonitor's own reply
        entry = PENDING.take((message.get_destination(), message.get_reply_serial()))
        if entry is not None:
            if message.get_signature() == "u":
                entry["daemon_id"] = message.get_body().get_child_value(0).get_uint32()
                entry["daemon_bus"] = message.get_sender() or ""
            write(entry)
        return None
    if kind != Gio.DBusMessageType.METHOD_CALL:
        # The bus's NameAcquired/NameLost signals.
        return message
    # Every method call is swallowed: a monitor must never answer, and GDBus would
    # otherwise reply UnknownMethod on our behalf.
    if message.get_member() == "Notify" and message.get_signature() == "susssasa{sv}i":
        try:
            entry, hints = make_entry(message.get_body())
            if not notiflog.is_noise(entry, hints):
                PENDING.hold((message.get_sender(), message.get_serial()), entry)
        except Exception as exc:
            log(f"record failed: {exc!r}")
    return None


def main():
    loop = GLib.MainLoop()
    status = {"code": 0}

    def stop(code):
        status["code"] = code
        loop.quit()
        return GLib.SOURCE_REMOVE

    address = Gio.dbus_address_get_for_bus_sync(Gio.BusType.SESSION, None)
    # A private connection: becoming a monitor turns the whole connection receive-only.
    connection = Gio.DBusConnection.new_for_address_sync(
        address,
        Gio.DBusConnectionFlags.AUTHENTICATION_CLIENT | Gio.DBusConnectionFlags.MESSAGE_BUS_CONNECTION,
        None,
        None,
    )
    connection.set_exit_on_close(False)
    connection.add_filter(on_message)
    connection.connect("closed", lambda *_: GLib.idle_add(stop, 1))
    connection.call_sync(
        "org.freedesktop.DBus",
        "/org/freedesktop/DBus",
        "org.freedesktop.DBus.Monitoring",
        "BecomeMonitor",
        GLib.Variant("(asu)", ([MATCH_CALLS, MATCH_REPLIES], 0)),
        None,
        Gio.DBusCallFlags.NONE,
        -1,
        None,
    )
    log(f"monitoring Notify calls into {notiflog.LOG_PATH}")
    for signum in (signal.SIGTERM, signal.SIGINT):
        GLib.unix_signal_add(GLib.PRIORITY_DEFAULT, signum, stop, 0)
    loop.run()
    PENDING.flush()
    if status["code"]:
        log("session bus connection closed")
    return status["code"]
