#!/bin/sh
sleep 30s
while [ 1 = 1 ]; do

    sleep 30s
    if [ `kactivities-cli --current-activity | grep "Main" | wc -l` -gt 0 ]; then
        exit 0
    fi

    tomato=`ps -aux | grep tomatoshell | wc -l`

    # If there are less than 2 instances of tomato, it means it is just grep and not tomato itself
    if [ $tomato -lt 2 ]; then
        kactivities-cli --set-current-activity `kactivities-cli --list-activities | grep "Main" | cut -d' ' -f2`
        notify-send --icon=`kactivities-cli --list-activities | grep "OXO" | cut -d' ' -f4` -a "OXO Innovation" "Start a pomodoro to Work"
    fi
done

# kactivities-cli --stop-activity `kactivities-cli --list-activities | grep "Main" | cut -d' ' -f2`
# notify-send --icon=`kactivities-cli --list-activities | grep "OXO" | cut -d' ' -f4` -a "OXO Innovation" "Main profile closed"
