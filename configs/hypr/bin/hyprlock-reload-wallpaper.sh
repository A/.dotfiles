#! /bin/bash

echo "$(find ~/Pictures/Wallpapers/ -type f -name '*.jpg' | shuf -n 1)"
