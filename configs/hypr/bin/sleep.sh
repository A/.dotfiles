#!/bin/bash

# Run swaylock if it's not already running
if pgrep -x "swaylock" > /dev/null
then
  echo "Skip locking, swaylock is already running" >> ~/.tmp/logs/sleep.log
else
  echo "Start swaylock" >> ~/.tmp/logs/sleep.log
  swaylock --grace=0 --fade-in=0 -fF
fi

systemctl suspend
