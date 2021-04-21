#!/bin/bash
set -e

INT=eDP-1
EXT_1=DP-1-1
EXT_2=DP-1-2

MODELINE=$(cvt 3840 2160 30 | grep -i modeline | sed "s/Modeline\ //")
MODENAME=$(echo $MODELINE | awk -F" " '{print $1}')

xrandr --newmode ${MODELINE} || true

xrandr --addmode ${EXT_1} ${MODENAME}
xrandr --addmode ${EXT_2} ${MODENAME}

xrandr --output ${EXT_1} --mode ${MODENAME} --scale 1 --pos 0x0 --primary
xrandr --output ${EXT_2} --mode ${MODENAME} --scale 1 --pos 5790x0

INTERNAL_MODELINE=$(cvt 2560 1440 60 | grep -i modeline | sed "s/Modeline\ //")
INTERNAL_MODENAME=$(echo $INTERNAL_MODELINE | awk -F" " '{print $1}')

xrandr --newmode ${INTERNAL_MODELINE} || true

xrandr --verbose --addmode ${INT} ${INTERNAL_MODENAME}
xrandr --verbose --output ${INT} --mode ${INTERNAL_MODENAME} --scale 1 --pos 1690x3240
