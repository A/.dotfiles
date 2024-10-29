#! /usr/bin/zsh
set -e

source ~/.zshrc

if [ -z "${1}" ]; then
  exit 124
fi

unsplash download -d ~/Pictures/Wallpapers --token $UNSPLASH_TOKEN -H --min-width 3840 --min-height 2160 -c "${1}"
