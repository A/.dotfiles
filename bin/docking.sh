#!/bin/bash

DISPLAY_IDS="DP1 DP1-2"

MODELINE=$(cvt 3840 2160 30 | grep -i modeline | sed "s/Modeline\ //")
MODENAME=$(echo $MODELINE | awk -F" " '{print $1}')

xrandr --newmode ${MODELINE}

for DISPLAY_ID in $DISPLAY_IDS; do
  echo "Add mode ${MODENAME} to ${DISPLAY_ID}"
  xrandr --addmode ${DISPLAY_ID} ${MODENAME}
  echo "Set mode ${MODENAME} to ${DISPLAY_ID}"
  xrandr --verbose --output ${DISPLAY_ID} --mode "${MODENAME}"
done
