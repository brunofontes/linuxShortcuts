#!/bin/sh
setxkbmap -model abnt2 -layout br -variant ,abnt2
#xrandr --output HDMI-1 --mode 1280x800
#xrandr --output HDMI-2 --mode 1280x800
xrandr --output HDMI2 --mode 1280x800 --pos 0x0 --rate 59.79 \
       --output HDMI1 --mode 1280x800 --right-of HDMI2 --rate 60.00

