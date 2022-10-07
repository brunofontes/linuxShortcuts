#!/bin/sh
xrandr --output HDMI-1 --mode 1920x1080
xrandr --output HDMI-2 --mode 1920x1080
sleep 3
/bin/numlockx on
/home/bruno/Apps/linuxShortcuts/start-oxo.sh organize
