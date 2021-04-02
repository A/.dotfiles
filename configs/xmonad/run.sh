#!/bin/sh

for f in ~/.xmonad/config.d/*.sh; do
    source "${f}"
done

# docking.sh
