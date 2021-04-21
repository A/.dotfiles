#!/bin/sh

if [ -z "$(pgrep nitrogen)" ] ; then
    nitrogen --restore &
fi
