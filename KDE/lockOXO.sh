#!/bin/bash

# Goes back to OXO acitivity when working

[ $(pgrep -f 'lockOXO.sh' | wc -l) -gt 2 ] && exit 0
sleep 20s

while true; do
    current=`kactivities-cli --current-activity | grep "Main"`
    if [[ $current ]]; then
        beep
        echo "Closing activity..." | festival --tts &
        notify-send --icon=$(getIconFromKDEactivity OXO) -a "OXO Innovation" "Closing main screen..."
        sleep 2s
        kactivities-cli --set-current-activity `kactivities-cli --list-activities | grep "OXO" | cut -d' ' -f2`
    fi
    sleep 30s
done
