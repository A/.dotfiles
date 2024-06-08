#! /usr/bin/zsh
source ~/.zshrc


COLLECTION_ID=$(zenity --entry --title="Download Unsplash Collection" --text="Enter collection id:")

if [ -z "${COLLECTION_ID}" ]; then
  zenity --info --text="No collection id specified"
  exit 1
fi

unsplash download -d ~/Pictures/Wallpapers --token $UNSPLASH_TOKEN -H --min-width 3840 --min-height 2160 -c "${COLLECTION_ID}"
