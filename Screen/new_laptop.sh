#!/bin/sh
setxkbmap -model abnt2 -layout br -variant ,abnt2
xrandr --output HDMI-1 --mode 1280x720  #Max resolution monitor can do that fits blackout
xrandr --output HDMI-1 --mode 1366x768  #Max resolution monitor can do that fits blackout
xrandr --output HDMI-2 --mode 1366x768

win_list=$(wmctrl -x -l | grep -i "OXO|" | awk '{print $1}' )
for win in "${win_list[@]}"
do
    wmctrl -r "$win" -i -b add,maximized_vert,maximized_horz
done
