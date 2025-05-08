#! /bin/bash

case $(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference) in
  "power")
    ICON="󰡳 "
    ;;

  "balance_power")
    ICON="󰡵 "
    ;;

  "balance_performance")
    ICON="󰊚 "
    ;;

  "performance")
    ICON="󰡴 "
    ;;
  *)
    ICON=" "
    ;;
esac

POWER_USAGE=$(awk '{print $1*10^-6}' /sys/class/power_supply/BAT0/power_now)

echo "${ICON} ${POWER_USAGE}W"
