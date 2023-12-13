#!/bin/sh
setxkbmap -model abnt2 -layout br -variant ,abnt2
#exit 0

# 1280x720 = Max resolution monitor can do that fits blackout

xrandr --output HDMI-A-1 --mode 1366x768 --pos 0x0 --rate 59.79 \
       --output HDMI-A-0 --mode 1280x720 --right-of HDMI-A-1 --rate 60.00

#xrandr --output HDMI1 --mode 1280x720  #Max resolution monitor can do that fits blackout
#xrandr --output HDMI2 --mode 1366x768

win_list=$(wmctrl -x -l | grep -i "OXO|" | awk '{print $1}' )
for win in "${win_list[@]}"
do
    wmctrl -r "$win" -i -b add,maximized_vert,maximized_horz
done
echo "blackout" > /home/bruno/.layout
