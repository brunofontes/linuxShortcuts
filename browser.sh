#!/bin/bash
activity=`kactivities-cli --current-activity | cut -d" " -f3`

if [[ $1 =~ .*\&incognitottt$ ]]; then
    url="${1/\&incognitottt/}"
    [[ $activity == "OXO" ]] && /bin/brave --incognito "$url" 2>%1 1>/dev/null &
    [[ $activity == "Development" ]] && /home/bruno/Apps/firefox/firefox-bin --private-window "$url" 2>%1 1>/dev/null &
    [[ $activity == "Main" ]] && /bin/firefox --private-window "$url" 2>%1 1>/dev/null &
    [[ $activity == "Videos" ]] && /bin/firefox --private-window "$url" 2>%1 1>/dev/null &
else
    [[ $activity == "OXO" ]] && /bin/brave "$1" 2>%1 1>/dev/null &
    [[ $activity == "Development" ]] && /home/bruno/Apps/firefox/firefox-bin "$1" 2>%1 1>/dev/null &
    [[ $activity == "Main" ]] && /bin/firefox "$1" 2>%1 1>/dev/null &
    [[ $activity == "Videos" ]] && /bin/firefox "$1" 2>%1 1>/dev/null &
fi
