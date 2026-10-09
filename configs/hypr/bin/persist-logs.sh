#!/usr/bin/env bash
# Mirror the Hyprland instance log from tmpfs into ~/.tmp/logs so crash
# evidence survives a reboot. Keeps the last 5 runs.

LOG_DIR="$HOME/.tmp/logs"
SRC="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/hyprland.log"

[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] || exit 1
mkdir -p "$LOG_DIR"

ls -t "$LOG_DIR"/hyprland-*.log 2>/dev/null | tail -n +5 | xargs -r rm --

exec tail -F -n +1 "$SRC" > "$LOG_DIR/hyprland-$(date +%Y%m%d-%H%M%S).log" 2>/dev/null
