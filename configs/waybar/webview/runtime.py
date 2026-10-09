"""Find or start an app's background UI server and open its pages in the native viewer.

Shared by gh-feed and notif-center, mirroring musictl's web runtime: the server
picks a free port and records it in $XDG_RUNTIME_DIR/<app>/server.json; `ui`
reuses it while /api/health answers with the app's name, otherwise spawns a
detached `<app> serve`.
"""

import json
import os
import shutil
import subprocess
import sys
import time
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path

VIEWER = Path(__file__).parent / "viewer.pyw"
SYSTEM_PYTHON = "/usr/bin/python3"
START_TIMEOUT_S = 10.0


@dataclass(frozen=True)
class Runtime:
    app: str
    app_id: str
    title: str

    @property
    def runtime_dir(self):
        base = os.environ.get("XDG_RUNTIME_DIR") or f"/tmp/{self.app}-{os.getuid()}"
        return Path(base) / self.app

    @property
    def state_file(self):
        return self.runtime_dir / "server.json"

    def write_state(self, port):
        path = self.state_file
        path.parent.mkdir(parents=True, exist_ok=True)
        tmp = path.with_suffix(".tmp")
        tmp.write_text(json.dumps({"pid": os.getpid(), "port": port}))
        os.replace(tmp, path)

    def clear_state(self):
        try:
            if json.loads(self.state_file.read_text()).get("pid") == os.getpid():
                self.state_file.unlink()
        except (OSError, ValueError):
            pass

    def read_state(self):
        try:
            state = json.loads(self.state_file.read_text())
        except (OSError, ValueError):
            return None
        return state if isinstance(state, dict) else None

    def healthy(self, port):
        try:
            with urllib.request.urlopen(f"http://127.0.0.1:{port}/api/health", timeout=1) as resp:
                return json.loads(resp.read()).get("app") == self.app
        except (OSError, ValueError, urllib.error.URLError):
            return False

    def running_port(self):
        state = self.read_state()
        if state is None:
            return None
        port = state.get("port")
        return port if isinstance(port, int) and self.healthy(port) else None

    def ensure_server(self, serve_command):
        """Port of a healthy server, spawning `serve_command` detached if there is none."""
        port = self.running_port()
        if port is not None:
            return port
        log = self.runtime_dir / "server.log"
        log.parent.mkdir(parents=True, exist_ok=True)
        with log.open("ab") as out:
            subprocess.Popen(
                serve_command,
                stdin=subprocess.DEVNULL,
                stdout=out,
                stderr=out,
                start_new_session=True,
            )
        deadline = time.monotonic() + START_TIMEOUT_S
        while time.monotonic() < deadline:
            port = self.running_port()
            if port is not None:
                return port
            time.sleep(0.1)
        raise RuntimeError(f"UI server did not start, see {log}")

    def open_page(self, url):
        """Open the native viewer (system python + GTK4/WebKitGTK); it falls back to xdg-open itself."""
        if os.access(SYSTEM_PYTHON, os.X_OK):
            cmd = [SYSTEM_PYTHON, str(VIEWER), "--app-id", self.app_id, "--title", self.title, url]
        elif shutil.which("xdg-open"):
            print(f"warning: {SYSTEM_PYTHON} not found, opening in the browser", file=sys.stderr)
            cmd = ["xdg-open", url]
        else:
            raise RuntimeError(f"No viewer available, open {url} manually")
        subprocess.Popen(cmd, stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL, stderr=None, start_new_session=True)
