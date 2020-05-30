# Media Keys Handlers

## Scripts

- `backlight` custom backlight control script for acpilight/xbacklight backend

## Notifications

Notification wrappers are bounded to dunst notification daemon.

- `notify-backlight` - shows current backlight value
- `notify-volume` - shows volume state, depends on pulseaudio

## UDEV Rules

- `backlight.rules` - puts /sys/class/backlight under `video` group
