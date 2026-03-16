#!/bin/bash
# Rename kitty window title (for use with hyprland groups/tabs)

# Get active window info
active_window=$(hyprctl activewindow -j)
window_class=$(echo "$active_window" | jq -r '.class')

if [[ "$window_class" != "kitty" ]]; then
    notify-send "Rename Tab" "Only works with kitty windows"
    exit 1
fi

# Get PID of the kitty window
kitty_pid=$(echo "$active_window" | jq -r '.pid')

# Prompt for new name
new_title=$(echo "" | wofi --dmenu -p "Tab name:")

# Set the title if user provided one
if [[ -n "$new_title" ]]; then
    kitty @ --to unix:/tmp/kitty-"$kitty_pid" set-window-title "$new_title"
fi
