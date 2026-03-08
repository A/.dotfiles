#!/bin/bash
# Show beets metadata for currently playing mpd track

# Check if mpd is playing
if ! mpc status 2>/dev/null | grep -q '\[playing\]'; then
    exit 0
fi

# Get current file path from mpd (relative to music dir)
current_file=$(mpc current -f '%file%' 2>/dev/null)
[ -z "$current_file" ] && exit 0

# Query beets using full path
full_path="$HOME/Music/$current_file"
folder=$(beet ls -f '$folder' "path:$full_path" 2>/dev/null | head -1)
tags=$(beet ls -f '$tags' "path:$full_path" 2>/dev/null | head -1)
rating=$(beet ls -f '$rating' "path:$full_path" 2>/dev/null | head -1)

# Format: F:folder (or inbox if empty) T:tags
if [ -n "$folder" ]; then
    out="F:$folder"
else
    out="F:inbox"
fi

if [ -n "$tags" ]; then
    out="$out T:$tags"
fi

if [ -n "$rating" ]; then
    out="$out R:$rating"
fi

echo "$out"
