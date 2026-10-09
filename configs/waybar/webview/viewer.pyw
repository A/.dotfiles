#!/usr/bin/python3
"""Native window for a local webview app: GTK4 + WebKitGTK 6.0 on the SYSTEM python.

Run as `/usr/bin/python3 viewer.pyw --app-id ID --title TITLE URL`, adapted from
musictl's viewer and shared by gh-feed and notif-center. The app id is the
window's class (Hyprland rules match on it) and the single-instance key: a
second invocation with the same id navigates the open window.
The page closes the window through the `webview` script message handler.
"""

import subprocess
import sys
from urllib.parse import urlsplit

ALLOWED_HOSTS = ("127.0.0.1",)
USAGE = "usage: viewer.pyw --app-id ID --title TITLE URL [--devtools]"


def open_external(url: str) -> None:
    # Only web links leave the window: xdg-open on file:// or a custom scheme would run a local handler.
    if urlsplit(url).scheme not in ("http", "https"):
        print(f"viewer: refusing to open {url!r}", file=sys.stderr)
        return
    subprocess.Popen(["xdg-open", url], stdin=subprocess.DEVNULL, start_new_session=True)


def is_local(url: str) -> bool:
    parts = urlsplit(url)
    return parts.scheme in ("http", "about") and (parts.scheme == "about" or parts.hostname in ALLOWED_HOSTS)


def parse_args(argv: list[str]):
    opts = {"--app-id": "", "--title": ""}
    devtools = False
    url = ""
    args = iter(argv[1:])
    for arg in args:
        if arg in opts:
            opts[arg] = next(args, "")
        elif arg == "--devtools":
            devtools = True
        else:
            url = arg
    if not opts["--app-id"] or not url:
        return None
    return opts["--app-id"], opts["--title"] or opts["--app-id"], url, devtools


def main(argv: list[str]) -> int:
    parsed = parse_args(argv)
    if parsed is None:
        print(USAGE, file=sys.stderr)
        return 2
    app_id, title, url, devtools = parsed
    try:
        import gi  # noqa: PLC0415

        gi.require_version("Gdk", "4.0")
        gi.require_version("Gtk", "4.0")
        gi.require_version("WebKit", "6.0")
        from gi.repository import Gdk, Gio, Gtk, WebKit  # noqa: PLC0415
    except (ImportError, ValueError) as e:
        print(f"warning: GTK4/WebKitGTK unavailable ({e}), opening in the browser", file=sys.stderr)
        open_external(url)
        return 0

    class Viewer(Gtk.Application):
        def __init__(self) -> None:
            super().__init__(application_id=app_id, flags=Gio.ApplicationFlags.HANDLES_COMMAND_LINE)
            self.window = None
            self.view = None
            self.failed = False

        def do_command_line(self, command_line):
            args = command_line.get_arguments()
            target = args[1] if len(args) > 1 else ""
            if not is_local(target):
                print(f"viewer: refusing non-local URL {target!r}", file=sys.stderr)
                return 1
            if self.window is None:
                self._build()
            self.failed = False
            self.view.load_uri(target)
            self.window.present()
            return 0

        def _build(self) -> None:
            WebKit.WebContext.get_default().set_cache_model(WebKit.CacheModel.DOCUMENT_VIEWER)
            manager = WebKit.UserContentManager()
            manager.register_script_message_handler("webview", None)
            manager.connect("script-message-received::webview", self._on_message)
            self.view = WebKit.WebView(
                network_session=WebKit.NetworkSession.new_ephemeral(), user_content_manager=manager
            )
            settings = self.view.get_settings()
            settings.set_enable_developer_extras(devtools)
            settings.set_enable_back_forward_navigation_gestures(False)
            self.view.connect("decide-policy", self._on_policy)
            self.view.connect("close", lambda *_: self.window.close())
            self.view.connect("notify::title", lambda v, _p: self.window.set_title(v.get_title() or title))

            self.window = Gtk.ApplicationWindow(application=self, title=title)
            self.window.set_default_size(900, 700)
            self.window.set_decorated(False)
            self.window.set_child(self.view)

            # Esc is handled by the page (dialogs first, then close); this covers a failed load.
            self.view.connect("load-failed", self._on_load_failed)
            keys = Gtk.EventControllerKey()
            keys.set_propagation_phase(Gtk.PropagationPhase.CAPTURE)
            keys.connect("key-pressed", self._on_key)
            self.window.add_controller(keys)

        def _on_message(self, _manager, value) -> None:
            if value.to_string() == "close":
                self.window.close()

        def _on_load_failed(self, *_args) -> bool:
            self.failed = True
            return False

        def _on_key(self, _ctrl, keyval, _code, state) -> bool:
            ctrl = bool(state & Gdk.ModifierType.CONTROL_MASK)
            if (keyval == Gdk.KEY_Escape and self.failed) or (ctrl and keyval in (Gdk.KEY_w, Gdk.KEY_q)):
                self.window.close()
                return True
            return False

        def _on_policy(self, _view, decision, kind) -> bool:
            if kind not in (WebKit.PolicyDecisionType.NAVIGATION_ACTION, WebKit.PolicyDecisionType.NEW_WINDOW_ACTION):
                return False
            uri = decision.get_navigation_action().get_request().get_uri()
            if kind == WebKit.PolicyDecisionType.NAVIGATION_ACTION and is_local(uri):
                return False
            decision.ignore()
            if not is_local(uri):
                open_external(uri)
            else:
                self.view.load_uri(uri)
            return True

    # GApplication sees only the URL: the primary instance reads it as args[1].
    return Viewer().run([argv[0], url])


if __name__ == "__main__":
    sys.exit(main(sys.argv))
