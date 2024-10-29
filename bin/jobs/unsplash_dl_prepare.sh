#! /usr/bin/zsh
set -e

COLLECTION_ID=$(zenity --entry --title="Download Unsplash Collection" --text="Enter collection id:")

if [ -z "${COLLECTION_ID}" ]; then
  zenity --info --text="No collection id specified"
  exit 1
fi

echo "${COLLECTION_ID}"
exit 0
