#!/bin/sh

# start apps if no parameter is sent
if [ -z $1 ]
then
    /bin/teams >/dev/null 2>&1 &
    /usr/lib/firefox/firefox -P OXO >/dev/null 2>&1 &
    /bin/terminator --title "Pomodoro" -x tmux new -t "Pomodoro" &>/dev/null &
    sleep 2
    kactivities-cli --set-current-activity `kactivities-cli --list-activities | grep "Main" | cut -d' ' -f2`
    sleep 120
fi

# TV
TOP_LEFT_TV="0,0,20,616,1016"
TOP_RIGHT_TV="0,640,20,1255,1016" 
TOP_LEFT_TV_BORDER="0,15,35,570,330"
TOP_RIGHT_TV_BORDER="0,620,35,1265,993" 

# MONITOR
TOP_LEFT_MONITOR="0,1935,0,570,973"
TOP_RIGHT_MONITOR="0,2560,0,1280,1046"  
TOP_LEFT_MONITOR_BORDER="0,1935,15,570,973"
TOP_RIGHT_MONITOR_BORDER="0,2540,15,1265,973"  

mainFirefox=$(wmctrl -l | grep -v "TickTick" | grep "OXO|" | awk '/Firefox/ { print $1 }')
ticktickFirefox=$(wmctrl -l | grep "TickTick" | grep "OXO|" | awk '/Firefox/ { print $1 }')
wmctrl -i -r "$ticktickFirefox" -b remove,maximized_vert,maximized_horz
wmctrl -i -r "$mainFirefox" -b remove,maximized_vert,maximized_horz
wmctrl -r "Pomodoro" -F -b remove,maximized_vert,maximized_horz
wmctrl -r "OXO|Plunet BusinessManager — Mozilla Firefox" -F -b remove,maximized_vert,maximized_horz

sleep 1

wmctrl -r "$ticktickFirefox" -e $TOP_LEFT_MONITOR_BORDER
wmctrl -r "$mainFirefox" -e $TOP_RIGHT_MONITOR_BORDER
wmctrl -r "Pomodoro" -F -e $TOP_LEFT_TV_BORDER
wmctrl -r "OXO|Plunet BusinessManager — Mozilla Firefox" -F -e $TOP_RIGHT_TV_BORDER

xdotool search "(.*) Microsoft Teams" windowminimize

if [ -z $1 ]
then
    sleep 2
    kactivities-cli --set-current-activity `kactivities-cli --list-activities | grep "OXO" | cut -d' ' -f2`
    tmux send -t Pomodoro $'echo "Press enter to start\!"; read; pdshell\n' &
    echo "OXO Activity prepared. You can start working" | festival --tts &
fi
