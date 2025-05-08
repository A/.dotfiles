#! /usr/bin/python3

# Dependencies:
# - hyprctl
# - jq

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
INTERVAL = 60
SUPPORTED_IMAGE_EXTS = ['.jpg', 'jpeg', '.png']


logging.basicConfig(
    format='wallpapers.py [%(levelname)s]: %(message)s',
    level=logging.DEBUG,
)


def get_wallpapers():
    wallpapers = Path(WALLPAPERS_DIR).glob("**/*.jpg")
    wallpapers = (p.resolve() for p in Path(WALLPAPERS_DIR).glob("**/*") if p.suffix in SUPPORTED_IMAGE_EXTS)
    wallpapers = [w for w in wallpapers]
    logging.info(f'Found {len(wallpapers)} wallpapers')
    return wallpapers


def get_displays():
    stdout = subprocess.check_output('hyprctl monitors -j | jq ".[].name"', shell=True).decode("utf-8")
    displays = stdout.replace('"', '').split('\n')
    displays = list(filter(len, displays))
    logging.info(f'Found {[d for d in displays]} displays')
    return displays

def set_wallpapers():
    displays = get_displays()
    subprocess.run("hyprctl hyprpaper unload all", shell=True)

    for display in displays:
        set_wallpaper(display)

def set_wallpaper(display):
        wallpapers = get_wallpapers()
        if not len(wallpapers):
            logging.warning("No wallpapers have been found")
            return

        wallpaper = random.choice(wallpapers)

        logging.info(f'Setting wallpaper for {display}: {wallpaper}')
        subprocess.run(f'hyprctl hyprpaper preload {wallpaper}', shell=True)
        time.sleep(2)
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


def main():
    if is_already_running():
        logging.warning("Script is already running. Exiting.")
        sys.exit(0)

    logging.info('Started')
    if 'delete' in sys.argv:
        delete_focused_wallpaper()
        return


    if 'next' in sys.argv:
        logging.info('Setting random wallpapers')
        set_wallpapers()
        return
    
    while True:
        logging.info('Start daemon')
        set_wallpapers()
        time.sleep(INTERVAL)

main()

