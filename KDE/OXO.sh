#!/bin/bash

# Goes back to Main if tomatoshell is not running

[ $(pgrep -f 'OXO.sh' | wc -l) -gt 2 ] && exit
sleep 30s

while [ 1 = 1 ]; do

    sleep 30s
    # If activity is not OXO, exit
    if [ `kactivities-cli --current-activity | grep "OXO" | wc -l` = 0 ]; then
        exit 0
    fi

    # If there are less than 2 instances of tomato, it means it is just grep and not tomato itself
    if [ ! $(pgrep -f /usr/local/bin/pdshell) ]; then
        beep
        echo "Start a pomodoro to work" | festival --tts &
        notify-send --icon=$(getIconFromKDEactivity OXO) -a "OXO Innovation" "Start a pomodoro to Work"
        sleep 2s
        kactivities-cli --set-current-activity $(kactivities-cli --list-activities | grep "Main" | cut -d' ' -f2)
    fi
done

# /bin/terminator -m -T Pomodoro -x tomatoshell --oxo
# kactivities-cli --stop-activity `kactivities-cli --list-activities | grep "Main" | cut -d' ' -f2`
# notify-send --icon=`kactivities-cli --list-activities | grep "OXO" | cut -d' ' -f4` -a "OXO Innovation" "Main profile closed"
