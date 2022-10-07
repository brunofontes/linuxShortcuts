#!/bin/bash
activity=`kactivities-cli --current-activity | cut -d" " -f3`

if [[ $1 =~ .*youtube\.com.* ]]; then
    mpv "$*" >/dev/null 2>&1 &
    exit
fi

if [[ $1 =~ .*youtu\.be.* ]]; then
    mpv "$*" >/dev/null 2>&1 &
    exit
fi

if [[ $1 =~ .*\&incognitottt$ ]]; then
    url="${1/\&incognitottt/}"
    [[ $activity == "OXO" ]] && /bin/brave --incognito "$url" >/dev/null 2>&1 &
    [[ $activity == "Development" ]] && /home/bruno/Apps/firefox/firefox-bin --private-window "$url" >/dev/null 2>&1 &
    [[ $activity == "Main" ]] && /bin/firefox --private-window "$url" >/dev/null 2>&1 &
    [[ $activity == "Videos" ]] && /bin/firefox --private-window "$url" >/dev/null 2>&1 &
else
    [[ $activity == "OXO" ]] && /bin/firefox -P OXO "$1" >/dev/null 2>&1 &
    [[ $activity == "Development" ]] && /home/bruno/Apps/firefox/firefox-bin "$1" >/dev/null 2>&1 &
    [[ $activity == "Main" ]] && /bin/firefox "$1" >/dev/null 2>&1 &
    [[ $activity == "Videos" ]] && /bin/firefox "$1" >/dev/null 2>&1 &
fi
