#!/bin/bash

STATE_FILE="$HOME/.tmp/idle-inhibit-active"
PID_FILE="$HOME/.tmp/idle-inhibit.pid"

start_inhibit() {
  systemd-inhibit --what=idle --who="waybar-inhibitor" --why="User requested idle inhibit" sleep infinity &
  echo $! > "$PID_FILE"
}

stop_inhibit() {
  if [[ -f "$PID_FILE" ]]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null
    rm -f "$PID_FILE"
  fi
}

case "${1:-}" in
  --toggle)
    if [[ -f "$STATE_FILE" ]]; then
      stop_inhibit
      rm -f "$STATE_FILE"
    else
      touch "$STATE_FILE"
      start_inhibit
    fi
    pkill -RTMIN+3 -x waybar
    ;;
  --restore)
    if [[ -f "$STATE_FILE" ]]; then
      stop_inhibit
      start_inhibit
    fi
    ;;
  *)
    # Status mode: output JSON for waybar
    if [[ -f "$STATE_FILE" ]]; then
      echo '{"text": "<span foreground=\"#ff4242\"></span>", "class": "activated", "tooltip": "Idle inhibitor: ON"}'
    else
      echo '{"text": "<span foreground=\"#999\"></span>", "class": "deactivated", "tooltip": "Idle inhibitor: OFF"}'
    fi
    ;;
esac
