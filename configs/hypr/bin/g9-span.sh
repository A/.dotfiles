#!/usr/bin/env bash
# Toggle "fake fullscreen" for the active window across both G9 PBP halves.
# On: float the window, stretch it over the bounding box of both G95NC
# monitors, and tell the client it is fullscreen (fullscreenstate 0 2) so
# players like YouTube hide their chrome. Off: restore previous geometry.
set -euo pipefail

win=$(hyprctl activewindow -j)
addr=$(jq -r '.address' <<<"$win")
[ "$addr" = "null" ] && exit 0

state_dir=${XDG_RUNTIME_DIR:-/tmp}/g9span
mkdir -p "$state_dir"
state="$state_dir/${addr#0x}"

if [ -f "$state" ]; then
  read -r floating x y w h <"$state"
  hyprctl --batch "\
dispatch fullscreenstate 0 0; \
dispatch resizewindowpixel exact $w $h,address:$addr; \
dispatch movewindowpixel exact $x $y,address:$addr"
  [ "$floating" = "false" ] && hyprctl dispatch settiled "address:$addr"
  rm -f "$state"
  # unhide the external bar
  pkill -USR1 -f 'waybar --config.*external' || true
else
  # bounding box (logical coords) of both G9 halves; fall back to the
  # focused monitor if the G9 is not connected
  box=$(hyprctl monitors -j | jq -r '
    [.[] | select(.model == "Odyssey G95NC")
         | {x0: .x, y0: .y,
            x1: (.x + (.width  / .scale)),
            y1: (.y + (.height / .scale))}]
    | if length < 2 then empty else
        ([.[].x0] | min | tostring) + " " +
        ([.[].y0] | min | tostring) + " " +
        ((([.[].x1] | max) - ([.[].x0] | min)) | floor | tostring) + " " +
        ((([.[].y1] | max) - ([.[].y0] | min)) | floor | tostring)
      end')
  if [ -z "$box" ]; then
    box=$(hyprctl monitors -j | jq -r '.[] | select(.focused)
      | "\(.x) \(.y) \((.width / .scale) | floor) \((.height / .scale) | floor)"')
  fi
  read -r bx by bw bh <<<"$box"

  jq -r '"\(.floating) \(.at[0]) \(.at[1]) \(.size[0]) \(.size[1])"' <<<"$win" >"$state"
  hyprctl --batch "\
dispatch fullscreenstate 0 0; \
dispatch setfloating address:$addr; \
dispatch resizewindowpixel exact $bw $bh,address:$addr; \
dispatch fullscreenstate 0 2; \
dispatch movewindowpixel exact $bx $by,address:$addr"
  # hide the external bar so it does not sit on top of the video
  pkill -USR1 -f 'waybar --config.*external' || true
fi
