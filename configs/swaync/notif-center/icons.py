"""Resolve a notification's icon name to a file, the way an XDG icon theme would.

A stdlib walk of the freedesktop icon theme spec (index.theme Directories and
Inherits, hicolor last, then /usr/share/pixmaps) rather than Gtk.IconTheme: the
server stays stdlib-only and does not hold GTK's ~70 MB for a few lookups.
The theme is the one GTK apps here actually use: GTK4 on Wayland takes it from
gsettings (the settings portal), so that wins over settings.ini.
"""

import configparser
import functools
import os
import subprocess
from pathlib import Path

EXTENSIONS = (".svg", ".png")
PIXMAPS = Path("/usr/share/pixmaps")


def data_dirs():
    home = Path(os.environ.get("XDG_DATA_HOME") or Path.home() / ".local" / "share")
    dirs = os.environ.get("XDG_DATA_DIRS") or "/usr/local/share:/usr/share"
    return [home, *(Path(d) for d in dirs.split(":") if d)]


def icon_bases():
    return [Path.home() / ".icons", *(d / "icons" for d in data_dirs())]


def gsettings_theme():
    try:
        result = subprocess.run(
            ["gsettings", "get", "org.gnome.desktop.interface", "icon-theme"],
            capture_output=True,
            text=True,
            timeout=2,
            check=False,
        )
    except (OSError, subprocess.TimeoutExpired):
        return ""
    return result.stdout.strip().strip("'") if result.returncode == 0 else ""


def ini_theme():
    config = Path(os.environ.get("XDG_CONFIG_HOME") or Path.home() / ".config")
    for name in ("gtk-4.0", "gtk-3.0"):
        parser = configparser.ConfigParser(interpolation=None)
        try:
            parser.read(config / name / "settings.ini", encoding="utf-8")
            theme = parser.get("Settings", "gtk-icon-theme-name", fallback="")
        except configparser.Error:
            theme = ""
        if theme:
            return theme
    return ""


def read_index(theme):
    """(directories ordered biggest/scalable first, inherited theme names), or None if the theme is absent."""
    for base in icon_bases():
        index = base / theme / "index.theme"
        if not index.is_file():
            continue
        parser = configparser.ConfigParser(interpolation=None, strict=False)
        try:
            parser.read(index, encoding="utf-8")
        except (configparser.Error, UnicodeDecodeError):
            return [], []
        section = parser["Icon Theme"] if parser.has_section("Icon Theme") else {}
        names = [d for d in section.get("Directories", "").split(",") if d]
        names += [d for d in section.get("ScaledDirectories", "").split(",") if d and d not in names]

        def rank(d):
            info = parser[d] if parser.has_section(d) else {}
            scalable = info.get("Type", "") == "Scalable"
            try:
                size = int(info.get("Size", "0")) * int(info.get("Scale", "1"))
            except ValueError:
                size = 0
            return (not scalable, -size)

        inherits = [t.strip() for t in section.get("Inherits", "").split(",") if t.strip()]
        return sorted(names, key=rank), inherits
    return None


@functools.cache
def theme_chain():
    """[(theme, directories)] in lookup order: the user's theme, what it inherits, hicolor."""
    chain, seen = [], set()
    queue = [gsettings_theme() or ini_theme() or "hicolor"]
    while queue:
        theme = queue.pop(0)
        if theme in seen:
            continue
        seen.add(theme)
        index = read_index(theme)
        if index is None:
            continue
        dirs, inherits = index
        chain.append((theme, dirs))
        queue.extend(inherits)
    if "hicolor" not in seen:
        index = read_index("hicolor")
        if index is not None:
            chain.append(("hicolor", index[0]))
    return chain


@functools.cache
def lookup(name):
    """Absolute path of icon `name`, or None."""
    if not name or "/" in name or name.startswith("."):
        return None
    for theme, dirs in theme_chain():
        for base in icon_bases():
            root = base / theme
            if not root.is_dir():
                continue
            for d in dirs:
                for ext in EXTENSIONS:
                    path = root / d / f"{name}{ext}"
                    if path.is_file():
                        return path
    for ext in EXTENSIONS:
        path = PIXMAPS / f"{name}{ext}"
        if path.is_file():
            return path
    return None


@functools.cache
def desktop_icon(desktop_entry):
    """Icon= of `<desktop_entry>.desktop` in the applications dirs; a name or an absolute path."""
    if not desktop_entry or "/" in desktop_entry:
        return ""
    for d in data_dirs():
        path = d / "applications" / f"{desktop_entry}.desktop"
        try:
            text = path.read_text(encoding="utf-8")
        except (OSError, UnicodeDecodeError):
            continue
        in_entry = False
        for line in text.splitlines():
            line = line.strip()
            if line.startswith("["):
                in_entry = line == "[Desktop Entry]"
            elif in_entry and line.startswith("Icon="):
                return line[5:].strip()
        return ""
    return ""
