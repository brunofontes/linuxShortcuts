#!/bin/sh

isFirefoxRunning=$(pgrep --exact "firefox" -a | grep -v "OXO")
if [[ -z $isFirefoxRunning ]]
then
    echo "Starting Firefox..."
    /usr/lib/firefox/firefox >/dev/null 2>&1 &
    notify-send "Opening Firefox, please wait..."
    sleep 20
fi

mainFirefox=$(wmctrl -l | grep -v "TickTick" | grep -v "OXO|" | awk '/Mozilla Firefox/ { print $1 }')
TickTickFirefox=$(wmctrl -l | grep "TickTick" | grep -v "OXO|" | awk '/Mozilla Firefox/ { print $1 }')
echo "Main Firefox window id: $mainFirefox"
echo " TickTick FF window id: $TickTickFirefox"

# MONITOR
TOP_LEFT_MONITOR="0,1935,0,570,973"
TOP_RIGHT_MONITOR="0,2560,0,1280,1046"  
TOP_LEFT_MONITOR_BORDER="0,1935,15,570,973"
TOP_RIGHT_MONITOR_BORDER="0,2540,15,1265,973"  

if [[ -z $mainFirefox ]]
then
    notify-send "Main Firefox not found"
else
    for w in "$mainFirefox"
    do
        sleep 0.5
        wmctrl -i -r "$w" -b remove,maximized_vert,maximized_horz
        sleep 0.5
        wmctrl -i -r "$w" -e $TOP_RIGHT_MONITOR_BORDER
    done
fi

sleep 1

if [[ -z $TickTickFirefox ]]
then
    notify-send "TickTick Firefox not found"
else
    wmctrl -i -r "$TickTickFirefox" -b remove,maximized_vert,maximized_horz
    wmctrl -i -r "$TickTickFirefox" -e $TOP_LEFT_MONITOR_BORDER
fi
