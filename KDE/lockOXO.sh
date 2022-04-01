#!/bin/sh
sleep 5s
while [ 1 = 1 ]; do
    current=`kactivities-cli --current-activity | grep "Main"`
    if [[ $current ]]; then
        kactivities-cli --stop-activity `kactivities-cli --list-activities | grep "Main" | cut -d' ' -f2`
        notify-send --icon=`kactivities-cli --list-activities | grep "OXO" | cut -d' ' -f4` -a "OXO Innovation" "Main profile closed"
    fi
    sleep 20s
done
