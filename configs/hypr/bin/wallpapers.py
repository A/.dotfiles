#! /bin/python
# Dependencies:
# - hyprctl
# - jq
# - imagemagick (convert, identify commands)

import json
import sys
import os
import logging
import subprocess
import random
import time
from pathlib import Path
import subprocess

def is_already_running():
    try:
        script_path = os.path.abspath(__file__)
        current_pid = os.getpid()
        output = subprocess.check_output(f"pgrep -f {script_path}", shell=True).decode("utf-8")
        pids = [int(pid) for pid in output.strip().split("\n") if pid.strip()]
        return any(pid != current_pid for pid in pids)
    except subprocess.CalledProcessError:
        return False


WALLPAPERS_DIR = os.path.expanduser("~/Pictures/Wallpapers")
ULTRAWIDE_DIR = os.path.join(WALLPAPERS_DIR, "ultrawide")
CACHE_DIR = os.path.expanduser("~/.cache/wallpapers")
INTERVAL = 60
SUPPORTED_IMAGE_EXTS = ['.jpg', '.jpeg', '.png']
THEME_FILE = os.path.expanduser("~/.wallpaper_theme") # File to store theme preference
# Monitors that form a single span (e.g. PBP halves of one panel). Matched by model.
SPAN_MODEL = "Odyssey G95NC"

logging.basicConfig(
    format='wallpapers.py [%(levelname)s]: %(message)s',
    level=logging.DEBUG,
)

def print_help():
    """Print help message with available commands"""
    help_text = """
    Wallpaper Script Usage:
    
    next            - Set random wallpaper based on current theme
    delete          - Delete the current wallpaper
    theme dark      - Set theme to dark wallpapers
    theme light     - Set theme to light wallpapers 
    theme any       - Use any wallpaper (no theme filtering)
    analyze         - Analyze and count dark/light wallpapers
    help            - Show this help message
    
    With no arguments, script runs as daemon changing wallpapers every {0} seconds.
    """.format(INTERVAL)
    
    print(help_text)#! /usr/bin/python3


def is_dark_image(image_path, threshold=35):
    """
    Determines if an image is dark or light using ImageMagick
    
    Args:
        image_path: Path to image file
        threshold: Value between 0-100, images with brightness below this are considered dark
        
    Returns:
        Boolean: True if image is dark, False if light, None if analysis failed
    """
    try:
        # Use imagemagick to get mean brightness
        cmd = f"convert '{image_path}' -colorspace Gray -format '%[mean]' info:"
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        
        if result.returncode != 0:
            logging.error(f"Error analyzing image {image_path}: {result.stderr}")
            return None
            
        mean_value = float(result.stdout.strip())
        # ImageMagick returns values between 0-65535, normalize to 0-100
        brightness_percentage = (mean_value / 65535) * 100
        
        return brightness_percentage < threshold
    except Exception as e:
        logging.error(f"Error analyzing image {image_path}: {e}")
        # Return None if we can't analyze the image
        return None

def get_theme():
    """Get the current theme preference (dark or light)"""
    if os.path.exists(THEME_FILE):
        with open(THEME_FILE, 'r') as f:
            theme = f.read().strip()
            return theme if theme in ['dark', 'light'] else 'any'
    return 'any'  # Default theme if not set

def set_theme(theme):
    """Set the theme preference"""
    if theme not in ['dark', 'light', 'any']:
        logging.error(f"Invalid theme: {theme}. Must be 'dark', 'light', or 'any'")
        return False
    
    with open(THEME_FILE, 'w') as f:
        f.write(theme)
    logging.info(f"Theme set to: {theme}")
    return True

def get_wallpapers():
    """Get all regular wallpapers (excludes the ultrawide span pool)"""
    uw = os.path.realpath(ULTRAWIDE_DIR)
    wallpapers = [
        p.resolve() for p in Path(WALLPAPERS_DIR).glob("**/*")
        if p.suffix.lower() in SUPPORTED_IMAGE_EXTS
        and not os.path.realpath(p).startswith(uw)
    ]
    logging.info(f'Found {len(wallpapers)} wallpapers')
    return wallpapers


def get_ultrawide_wallpapers():
    """Get wallpapers meant to span the PBP pair"""
    if not os.path.isdir(ULTRAWIDE_DIR):
        return []
    wallpapers = [p.resolve() for p in Path(ULTRAWIDE_DIR).glob("**/*") if p.suffix.lower() in SUPPORTED_IMAGE_EXTS]
    logging.info(f'Found {len(wallpapers)} ultrawide wallpapers')
    return wallpapers


def get_monitors():
    stdout = subprocess.check_output('hyprctl monitors -j', shell=True).decode("utf-8")
    monitors = json.loads(stdout)
    logging.info(f'Found {[m["name"] for m in monitors]} displays')
    return monitors


def get_displays():
    return [m["name"] for m in get_monitors()]


def find_span_monitors(monitors):
    """Return SPAN_MODEL monitors ordered left->right (2 = PBP pair, 1 = single input)"""
    span = [m for m in monitors if m.get("model") == SPAN_MODEL]
    span.sort(key=lambda m: m["x"])
    return span


def set_span_wallpaper(pair, wallpaper):
    """Crop an ultrawide image into left/right halves and set on the pair.

    Both halves are cropped up front, then applied back-to-back in a single
    shell call so the two displays update as close to simultaneously as
    possible (avoids a visible seam lag between halves).
    """
    os.makedirs(CACHE_DIR, exist_ok=True)
    dims = subprocess.check_output(f"identify -format '%w %h' '{wallpaper}'", shell=True).decode("utf-8").split()
    w, h = int(dims[0]), int(dims[1])
    half = w // 2
    targets = [
        (pair[0], os.path.join(CACHE_DIR, "span_left.png"), 0),
        (pair[1], os.path.join(CACHE_DIR, "span_right.png"), half),
    ]

    for mon, out, xoff in targets:
        subprocess.run(f"convert '{wallpaper}' -crop {half}x{h}+{xoff}+0 +repage '{out}'", shell=True)

    apply = " ; ".join(
        f"hyprctl hyprpaper wallpaper {mon['name']},{out}" for mon, out, _ in targets
    )
    subprocess.run(apply, shell=True)
    for mon, out, xoff in targets:
        logging.info(f"Span wallpaper {mon['name']} <- {wallpaper} (+{xoff})")


def set_wallpapers():
    """Set wallpapers on all displays"""
    monitors = get_monitors()

    handled = set()
    span = find_span_monitors(monitors)
    ultrawide = get_ultrawide_wallpapers()
    if span and ultrawide:
        wallpaper = random.choice(ultrawide)
        if len(span) == 2:
            set_span_wallpaper(span, wallpaper)
        else:
            # single-input G9: whole ultrawide image, no split
            name = span[0]["name"]
            logging.info(f'Setting ultrawide wallpaper for {name}: {wallpaper}')
            subprocess.run(f'hyprctl hyprpaper wallpaper {name},{wallpaper}', shell=True)
        handled = {m["name"] for m in span}

    for monitor in monitors:
        if monitor["name"] in handled:
            continue
        set_wallpaper(monitor["name"])

def set_wallpaper(display):
    """Set wallpaper for a specific display based on theme"""
    theme = get_theme()
    wallpapers = get_wallpapers()
    
    if not wallpapers:
        logging.warning("No wallpapers have been found")
        return
        
    # Only filter by theme if it's set to dark or light
    if theme in ['dark', 'light']:
        print(f"Theme: {theme}")
        max_attempts = 5
        for attempt in range(max_attempts):
            wallpaper = random.choice(wallpapers)
            is_dark = is_dark_image(wallpaper)
            
            # If analysis failed, try another one
            if is_dark is None:
                continue
                
            # If wallpaper matches theme, use it
            if (theme == 'dark' and is_dark) or (theme == 'light' and not is_dark):
                break
                
            # If this is our last attempt, use any wallpaper
            if attempt == max_attempts - 1:
                logging.warning(f"Could not find matching {theme} wallpaper after {max_attempts} attempts. Using any wallpaper.")
                wallpaper = random.choice(wallpapers)
    else:
        # For 'any' theme, just pick a random wallpaper
        wallpaper = random.choice(wallpapers)

    logging.info(f'Setting wallpaper for {display}: {wallpaper}')
    subprocess.run(f'hyprctl hyprpaper wallpaper {display},{wallpaper}', shell=True)

def get_focused_display():
    # Extract name of the monitor where focused is true
    stdout = subprocess.check_output(
        'hyprctl monitors -j | jq -r \'.[] | select(.focused == true)\'',
        shell=True
    ).decode("utf-8")
    return json.loads(stdout)

def get_active_wallpapers():
    stdout = subprocess.check_output(
        'hyprctl hyprpaper listactive',
        shell=True
    ).decode("utf-8")
    
    retval = {}
    print(stdout)
    print('\n')
    for item in stdout.split('\n'):
        if not item.strip():
            continue

        print(f"item {item}")
        [key, value] = item.split(' = ')
        retval[key] = value

    return retval


def delete_focused_wallpaper():
    display = get_focused_display()
    wallpapers_per_display = get_active_wallpapers()
    active_wallpaper_path = wallpapers_per_display[display['name']]

    print(f'Delete active wallpaper: {active_wallpaper_path}')

    command = [
        "yad",
        "--picture",
        "--filename", active_wallpaper_path,
        "--size=fit",
        "--center",
        "--button=Cancel:1",
        "--button=Delete:0"
    ]

    try:
        result = subprocess.run(command, check=True)
        exit_code = result.returncode
        
        if exit_code == 0:
            os.remove(active_wallpaper_path)
            print('Active wallpaper was deleted')
            set_wallpaper(display['name'])
            
    except subprocess.CalledProcessError as e:
        print(f"Skip. Exit code {e.returncode}")


def analyze_wallpapers():
    """Analyze and categorize all wallpapers"""
    wallpapers = get_wallpapers()
    dark_count = 0
    light_count = 0
    error_count = 0
    
    print(f"Analyzing {len(wallpapers)} wallpapers...")
    for wp in wallpapers:
        print(f"Analyzing {wp}")
        is_dark = is_dark_image(wp)
        if is_dark is True:
            print(f"> dark")
            dark_count += 1
        elif is_dark is False:
            print(f"> light")
            light_count += 1
        else:
            print(f"> error")
            error_count += 1
    
    print(f"Analysis complete:")
    print(f"- Dark wallpapers: {dark_count}")
    print(f"- Light wallpapers: {light_count}")
    if error_count > 0:
        print(f"- Failed to analyze: {error_count}")

def main():
    logging.info('Started')
    
    if len(sys.argv) > 1:
        if 'delete' in sys.argv:
            delete_focused_wallpaper()
            return
        
        elif 'next' in sys.argv:
            logging.info('Setting random wallpapers based on theme')
            set_wallpapers()
            return
            
        elif 'theme' in sys.argv and len(sys.argv) > 2:
            theme = sys.argv[2].lower()
            if theme in ['dark', 'light', 'any']:
                set_theme(theme)
                # Just set theme and call next wallpaper
                logging.info(f"Theme set to: {theme}, setting next wallpaper")
                set_wallpapers()
            else:
                logging.error(f"Invalid theme: {theme}. Use 'dark', 'light', or 'any'")
            return
            
        elif 'analyze' in sys.argv:
            analyze_wallpapers()
            return
            
        elif 'help' in sys.argv:
            print_help()
            return
    
    if is_already_running():
        logging.warning("Script is already running. Exiting.")
        sys.exit(0)
    
    while True:
        logging.info('Start daemon')
        set_wallpapers()
        time.sleep(INTERVAL)

if __name__ == "__main__":
    main()
