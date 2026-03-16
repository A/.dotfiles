#!/bin/bash

if pgrep -x "hyprlock" > /dev/null
then
  echo "$(date '+%Y-%m-%dT%T.%3N'): Skip locking, hyprlock is already running" >> ~/.tmp/logs/sleep.log
else
  echo "$(date '+%Y-%m-%dT%T.%3N'): Start locking" >> ~/.tmp/logs/sleep.log
  hyprlock -q --immediate &
  sleep 2
fi

# systemctl suspend-then-hibernate
systemctl suspend

# Reload i2c_hid_acpi after resume to fix trackpad (GXTP7385)
sudo modprobe -r i2c_hid_acpi && sudo modprobe i2c_hid_acpi
