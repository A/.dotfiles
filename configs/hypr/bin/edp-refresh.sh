#!/bin/bash

MONITOR="eDP-1"

apply() {
  local current rate
  current=$(hyprctl monitors -j | jq -r --arg m "$MONITOR" '.[] | select(.name == $m) | .refreshRate | round')
  [ -z "$current" ] && return

  if [ "$(cat /sys/class/power_supply/AC/online)" = "1" ]; then
    rate=120
  else
    rate=60
  fi

  # Compare against the live rate rather than a remembered one: `hyprctl reload` resets it to 120
  [ "$rate" = "$current" ] && return
  hyprctl keyword monitor "$MONITOR, 2880x1800@$rate, 3600x1440, 2" > /dev/null
}

if [ "$1" = "--once" ]; then
  apply
  exit
fi

exec 9> "${XDG_RUNTIME_DIR}/edp-refresh.lock"
flock -n 9 || exit 0

apply

if command -v udevadm > /dev/null; then
  udevadm monitor --subsystem-match=power_supply --udev
else
  upower --monitor
fi | while read -r _; do
  apply
done
