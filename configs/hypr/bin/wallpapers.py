#! /usr/bin/python3

# Dependencies:
# - hyprctl
# - jq

import sys
import os
import logging
import subprocess
import random
import time
from pathlib import Path


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
    wallpapers = get_wallpapers()
    displays = get_displays()

    if not len(wallpapers):
        logging.warning("No wallpapers have been found")
        return

    subprocess.run("hyprctl hyprpaper unload all", shell=True)

    for display in displays:
        wallpaper = random.choice(wallpapers)
        logging.info(f'Setting wallpaper for {display}: {wallpaper}')
        subprocess.run(f'hyprctl hyprpaper preload {wallpaper}', shell=True)
        time.sleep(2)
        subprocess.run(f'hyprctl hyprpaper wallpaper {display},{wallpaper}', shell=True)


def main():
    logging.info('Started')
    if 'next' in sys.argv:
        logging.info('Setting random wallpapers')
        set_wallpapers()
        return
    
    while True:
        logging.info('Start daemon')
        set_wallpapers()
        time.sleep(INTERVAL)

main()

