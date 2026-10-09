"""Local UI server base shared by gh-feed and notif-center: stdlib ThreadingHTTPServer,
JSON API + static files, 127.0.0.1 only, modelled on musictl's web UI.

Every /api/ route except /api/health requires the random per-process token that
the served index.html carries (header X-Webview-Token, or `t=` for <img> URLs),
and every request must name this server as its Host. A web page in a browser can
neither read the token nor pass the Host check, so it cannot drive or read the API.

An app supplies an `api` object with get(path, query) and post(path, body); a get
may return Image(path) to send a file instead of JSON. Static files come from the
app's own static dir first, then this module's (base.css, webview.js).

Stdlib only.
"""

import hmac
import json
import os
import secrets
import signal
import subprocess
import sys
from dataclasses import dataclass
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from typing import Any, ClassVar
from urllib.parse import parse_qs, urlsplit

SHARED_STATIC = Path(__file__).parent / "static"
STATIC_TYPES = {
    ".html": "text/html; charset=utf-8",
    ".css": "text/css; charset=utf-8",
    ".js": "text/javascript; charset=utf-8",
    ".svg": "image/svg+xml",
}
IMAGE_TYPES = {
    ".png": "image/png",
    ".jpg": "image/jpeg",
    ".jpeg": "image/jpeg",
    ".gif": "image/gif",
    ".webp": "image/webp",
    ".svg": "image/svg+xml",
}
IMAGE_MAGIC = (
    (b"\x89PNG\r\n\x1a\n", "image/png"),
    (b"\xff\xd8\xff", "image/jpeg"),
    (b"GIF8", "image/gif"),
    (b"RIFF", "riff"),
)
TOKEN_HEADER = "X-Webview-Token"
TOKEN_PLACEHOLDER = b"{{TOKEN}}"


class ApiError(Exception):
    def __init__(self, status, message):
        super().__init__(message)
        self.status = status


@dataclass(frozen=True)
class Image:
    path: Path | None


def is_web_url(url):
    return urlsplit(url or "").scheme in ("http", "https")


def open_url(url):
    """xdg-open a web link; anything else is refused so a stored string can't launch a local handler."""
    if not is_web_url(url):
        raise ApiError(HTTPStatus.BAD_REQUEST, "Not a web link")
    spawn(["xdg-open", url])


def spawn(command, data=None):
    if data is None:
        subprocess.Popen(
            command,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )
    else:
        subprocess.run(
            command,
            input=data,
            text=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        )


def image_type(data, path):
    """Content type from the magic bytes: caches may name a file .png whatever was served."""
    for magic, mime in IMAGE_MAGIC:
        if data.startswith(magic):
            return "image/webp" if mime == "riff" and data[8:12] == b"WEBP" else mime
    if data.lstrip()[:5] in (b"<?xml", b"<svg ") or path.suffix.lower() == ".svg":
        return "image/svg+xml"
    return IMAGE_TYPES.get(path.suffix.lower(), "application/octet-stream")


def mtime_ns(path):
    try:
        st = path.stat()
    except OSError:
        return 0
    return st.st_mtime_ns + st.st_size


def int_arg(value, name):
    try:
        return int(value)
    except (TypeError, ValueError):
        raise ApiError(HTTPStatus.BAD_REQUEST, f"'{name}' must be an integer") from None


class Handler(BaseHTTPRequestHandler):
    app: ClassVar[str]
    api: ClassVar[Any]
    token: ClassVar[str]
    host: ClassVar[str]
    pages: ClassVar[tuple[str, ...]]
    static_dirs: ClassVar[tuple[Path, ...]]

    def log_message(self, format, *args):
        # Silenced: the page polls every few seconds, which would flood server.log.
        del format, args

    def do_GET(self):
        url = urlsplit(self.path)
        path = url.path
        query = parse_qs(url.query)
        if not self._host_ok():
            return
        if path == "/api/health":
            self._json(HTTPStatus.OK, {"app": self.app, "pid": os.getpid()})
        elif path == "/":
            self._redirect(f"/{self.pages[0]}")
        elif path.strip("/") in self.pages:
            self._index()
        elif path.startswith("/static/"):
            self._static(path.removeprefix("/static/"))
        elif not path.startswith("/api/"):
            self._json(HTTPStatus.NOT_FOUND, {"error": "Not found"})
        elif self._token_ok(query):
            self._call(lambda: self.api.get(path, query))

    def do_POST(self):
        if not self._host_ok() or not self._token_ok({}):
            return
        # A JSON content type forces a CORS preflight, so other sites can't post here.
        if self.headers.get("Content-Type", "").split(";")[0].strip() != "application/json":
            self._json(HTTPStatus.UNSUPPORTED_MEDIA_TYPE, {"error": "Expected application/json"})
            return
        length = int(self.headers.get("Content-Length") or 0)
        try:
            body = json.loads(self.rfile.read(length) or b"{}")
        except json.JSONDecodeError:
            self._json(HTTPStatus.BAD_REQUEST, {"error": "Invalid JSON"})
            return
        if not isinstance(body, dict):
            self._json(HTTPStatus.BAD_REQUEST, {"error": "Expected a JSON object"})
            return
        path = urlsplit(self.path).path
        self._call(lambda: self.api.post(path, body))

    def _host_ok(self):
        # Rejects DNS rebinding: only our own loopback origin may talk to the server.
        if self.headers.get("Host") == self.host:
            return True
        self._json(HTTPStatus.FORBIDDEN, {"error": "Forbidden host"})
        return False

    def _token_ok(self, query):
        given = self.headers.get(TOKEN_HEADER) or query.get("t", [""])[0]
        if given and hmac.compare_digest(given.encode(), self.token.encode()):
            return True
        self._json(HTTPStatus.FORBIDDEN, {"error": "Bad token"})
        return False

    def _call(self, fn):
        try:
            result = fn()
        except ApiError as e:
            self._json(e.status, {"error": str(e)})
            return
        except Exception as e:
            print(f"{self.app} serve: API error on {self.path}: {e!r}", file=sys.stderr, flush=True)
            self._json(HTTPStatus.INTERNAL_SERVER_ERROR, {"error": str(e) or type(e).__name__})
            return
        if isinstance(result, Image):
            self._image(result.path)
        else:
            self._json(HTTPStatus.OK, result)

    def _index(self):
        data = (self.static_dirs[0] / "index.html").read_bytes().replace(TOKEN_PLACEHOLDER, self.token.encode())
        self._send(HTTPStatus.OK, data, STATIC_TYPES[".html"], cache="no-store")

    def _static(self, name):
        for root in self.static_dirs:
            base = root.resolve()
            target = (base / name).resolve()
            if (
                target.parent == base
                and target.name != "index.html"
                and target.suffix in STATIC_TYPES
                and target.is_file()
            ):
                self._send(HTTPStatus.OK, target.read_bytes(), STATIC_TYPES[target.suffix], cache="no-cache")
                return
        self._json(HTTPStatus.NOT_FOUND, {"error": "Not found"})

    def _image(self, path):
        try:
            data = path.read_bytes() if path else None
        except OSError:
            data = None
        if data is None:
            self._json(HTTPStatus.NOT_FOUND, {"error": "Not found"})
            return
        content_type = image_type(data, path)
        if content_type not in IMAGE_TYPES.values():
            self._json(HTTPStatus.NOT_FOUND, {"error": "Not found"})
            return
        self._send(HTTPStatus.OK, data, content_type, cache="private, max-age=300")

    def _redirect(self, location):
        self.send_response(HTTPStatus.FOUND)
        self.send_header("Location", location)
        self.send_header("Content-Length", "0")
        self.end_headers()

    def _json(self, status, payload):
        data = json.dumps(payload, ensure_ascii=False).encode()
        self._send(status, data, "application/json; charset=utf-8", cache="no-store")

    def _send(self, status, data, content_type, cache):
        self.send_response(status)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Cache-Control", cache)
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("Referrer-Policy", "no-referrer")
        if content_type.startswith(("text/html", "image/svg")):
            # SVG too: an icon opened as a document must not run script.
            self.send_header("Content-Security-Policy", "default-src 'self'; img-src 'self'; object-src 'none'")
        self.end_headers()
        self.wfile.write(data)


def make_server(app, api, static_dir, pages, port=0, host="127.0.0.1"):
    handler = type(
        "BoundHandler",
        (Handler,),
        {
            "app": app,
            "api": api,
            "token": secrets.token_urlsafe(32),
            "pages": tuple(pages),
            "static_dirs": (Path(static_dir), SHARED_STATIC),
        },
    )
    server = ThreadingHTTPServer((host, port), handler)
    handler.host = f"{host}:{server.server_port}"
    server.daemon_threads = True
    return server


def serve_forever(server, runtime):
    """Run until SIGTERM/^C, keeping the runtime state file in step with the server."""
    port = server.server_address[1]
    runtime.write_state(port)
    print(f"{runtime.app} UI on http://127.0.0.1:{port}/", flush=True)
    # `ui` spawns us detached; a plain kill must still drop the runtime state file.
    signal.signal(signal.SIGTERM, lambda *_: sys.exit(0))
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
        runtime.clear_state()
    return 0
