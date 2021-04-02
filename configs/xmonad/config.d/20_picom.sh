#!/bin/sh
if [ -z "$(pgrep picom)" ] ; then
    picom --experimental-backends &
fi

