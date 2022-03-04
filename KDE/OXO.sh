#!/bin/sh
kactivities-cli --stop-activity `kactivities-cli --list-activities | grep "Main" | cut -d' ' -f2`
notify-send --icon=`kactivities-cli --list-activities | grep "OXO" | cut -d' ' -f4` -a "OXO Innovation" "Main profile closed"
