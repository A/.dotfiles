#! /bin/bash

case $(cat /sys/firmware/acpi/platform_profile) in
  "low-power")
    ICON="󰾆 "
    ;;

  "balanced")
    ICON="󰾅 "
    ;;

  "performance")
    ICON="󰓅 "
    ;;
  *)
    ICON="󰾅 "
    ;;
esac

POWER_USAGE=$(awk '{print $1*10^-6}' /sys/class/power_supply/BAT0/power_now)

echo "${ICON} ${POWER_USAGE}W"
