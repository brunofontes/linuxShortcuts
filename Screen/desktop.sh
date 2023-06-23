#!/bin/sh

/bin/numlockx on

#xrandr --output HDMI1 --mode 1920x1080
#xrandr --output HDMI2 --mode 1920x1080

xrandr --output HDMI2 --mode 1920x1080 --pos 0x0 --rate 60.0 \
       --output HDMI1 --mode 1920x1080 --right-of HDMI2 --rate 74.97

sleep 3
/home/bruno/Apps/linuxShortcuts/start-oxo.sh "organize"
echo "desktop" > /home/bruno/.layout
