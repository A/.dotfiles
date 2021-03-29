#!/bin/bash
set -e

MODELINE=$(cvt 3840 2160 30 | grep -i modeline | sed "s/Modeline\ //")
MODENAME=$(echo $MODELINE | awk -F" " '{print $1}')

xrandr --newmode ${MODELINE} || true

xrandr --addmode DP1-1 ${MODENAME}
xrandr --addmode DP1-2 ${MODENAME}

xrandr --output DP1-1 --mode ${MODENAME} --scale 1.5 --pos 0x0 --primary
xrandr --output DP1-2 --mode ${MODENAME} --scale 1.5 --pos 5790x0

INTERNAL_MODELINE=$(cvt 2560 1440 60 | grep -i modeline | sed "s/Modeline\ //")
INTERNAL_MODENAME=$(echo $INTERNAL_MODELINE | awk -F" " '{print $1}')

xrandr --newmode ${INTERNAL_MODELINE} || true

xrandr --verbose --addmode eDP1 ${INTERNAL_MODENAME}
xrandr --verbose --output eDP1 --mode ${INTERNAL_MODENAME} --scale 1.6 --pos 1690x3240
