#!/bin/sh

if [[ -z $1 ]]
then
    # Teams
    # if [ -z $(xdotool search "(.*) Microsoft Teams") ]
    # then
    #     echo "Opening Team..."
    #     /bin/teams >/dev/null 2>&1 &
    #     openingProgram=1
    # fi

    # Browser

    # if [[ -z $(pgrep --exact "brave" -a) ]]
    # then
    #     echo "Opening Brave..."
    #     /usr/lib/brave-bin/brave >/dev/null 2>&1 &
    #     openingBrowser=1
    # fi
    if [[ -z $(pgrep --exact "firefox" -a | grep "OXO") ]]
    then
        echo "Opening Firefox..."
        /usr/lib/firefox/firefox -P OXO >/dev/null 2>&1 &
        openingBrowser=1
    fi

    # Pomodoro
    if [[ -z $(tmux ls | grep "Pomodoro") ]]
    then
        echo "Preparing Pomodoro Tool..."
        /bin/terminator --title "Pomodoro" -x "tmux new -t \"Pomodoro\"" &>/dev/null &
        sleep 2
        # kactivities-cli --set-current-activity $(kactivities-cli --list-activities | grep "Main" | cut -d' ' -f2)
        openingProgram=1
    fi

    if [ $openingProgram ]
    then
        sleep 5
    fi

    if [[ $openingBrowser ]]
    then
        sleep 120
    fi
fi

# TV
TOP_LEFT_TV="0,0,20,616,1016"
TOP_RIGHT_TV="0,640,20,1255,1016" 
TOP_LEFT_TV_BORDER="0,15,35,570,330"
TOP_RIGHT_TV_BORDER="0,620,35,1265,990" 

# MONITOR
TOP_LEFT_MONITOR="0,1935,0,570,973"
TOP_RIGHT_MONITOR="0,2560,0,1280,1046"  
TOP_LEFT_MONITOR_BORDER="0,1935,15,570,973"
TOP_RIGHT_MONITOR_BORDER="0,2540,15,1265,973"  

mainFirefox=$(wmctrl -l | grep -v "TickTick" | grep -v "Plunet" | grep "OXO|" | awk '/Firefox/ { print $1 }')
ticktickFirefox=$(wmctrl -l | grep "TickTick" | grep -v "Plunet" | grep "OXO|" | awk '/Firefox/ { print $1 }')
#mainBrowser=$(wmctrl -l | grep -v "TickTick" | grep -v "OXO|Plunet BusinessManager" |  awk '/Brave/ { print $1 }')
#ticktickBrowser=$(wmctrl -l | grep "TickTick" | grep -v "OXO|Plunet BusinessManager" |  awk '/Brave/ { print $1 }')

if [ $ticktickFirefox ]
then 
    wmctrl -i -r "$ticktickFirefox" -b remove,maximized_vert,maximized_horz 
fi
if [ $mainFirefox ]
then 
    wmctrl -i -r "$mainFirefox" -b remove,maximized_vert,maximized_horz 
fi
if [ $ticktickBrowser ]
then 
    wmctrl -i -r "$ticktickBrowser" -b remove,maximized_vert,maximized_horz 
fi
if [ $mainBrowser ]
then 
    wmctrl -i -r "$mainBrowser" -b remove,maximized_vert,maximized_horz 
fi
wmctrl -r "Pomodoro" -F -b remove,maximized_vert,maximized_horz
wmctrl -r "OXO|Plunet BusinessManager — Mozilla Firefox" -F -b remove,maximized_vert,maximized_horz

sleep 1

if [ $ticktickFirefox ]
then
    wmctrl -i -r "$ticktickFirefox" -e $TOP_LEFT_MONITOR_BORDER 
fi
if [ $mainFirefox ]
then 
    wmctrl -i -r "$mainFirefox" -e $TOP_RIGHT_MONITOR_BORDER 
fi
if [ $ticktickBrowser ]
then
    wmctrl -i -r "$ticktickBrowser" -e $TOP_LEFT_MONITOR_BORDER 
fi
if [ $mainBrowser ]
then 
    wmctrl -i -r "$mainBrowser" -e $TOP_RIGHT_MONITOR_BORDER 
fi

wmctrl -r "Pomodoro" -F -e $TOP_LEFT_TV_BORDER
wmctrl -r "OXO|Plunet BusinessManager — Mozilla Firefox" -F -e $TOP_RIGHT_TV_BORDER

xdotool search "(.*) Microsoft Teams" windowminimize

if [[ -z $1 ]]
then
    sleep 2
    echo "OXO Activity prepared. You can start working" | festival --tts
    zenity --question --text="Do you want to start working now?" || exit 0
    kactivities-cli --set-current-activity $(kactivities-cli --list-activities | grep "OXO" | cut -d' ' -f2)
    tmux send -t Pomodoro $'pdshell\n' &
fi
