#!/bin/sh
if [ -z "$(pgrep xbanish)" ] ; then
    xbanish &
fi

