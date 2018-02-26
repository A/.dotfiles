#!/bin/sh
i3-msg -s /home/anton/.i3/i3-ipc.sock "exec i3lock -ue -i ~/Images/_wallpaper.png"
pm-suspend
