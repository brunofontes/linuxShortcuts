#!/bin/zsh
activity=$(kactivities-cli --current-activity | cut -d" " -f3)

MPV=0
[[ $1 =~ .*youtube\.com.* ]] && MPV=1
[[ $1 =~ .*youtu\.be.* ]] && MPV=1
[[ $1 =~ .*peertube.* ]] && MPV=1
[[ $1 =~ .*yewtu\.be.* ]] && MPV=1

if [[ $MPV == "1" ]]; then
    mpv "$*" >/dev/null 2>&1 &
    exit 0
fi

# if [[ $1 =~ .*\&incognitottt$ ]]; then
#     url="${1/\&incognitottt/}"
#     [[ $activity == "OXO" ]] && /bin/brave --incognito "$url" >/dev/null 2>&1 &
#     [[ $activity == "Development" ]] && /home/bruno/Apps/firefox/firefox-bin --private-window "$url" >/dev/null 2>&1 &
#     [[ $activity == "Main" ]] && /bin/firefox --private-window "$url" >/dev/null 2>&1 &
#     [[ $activity == "Videos" ]] && /bin/firefox --private-window "$url" >/dev/null 2>&1 &
#     exit 0
# fi

[[ $activity == "OXO" ]] && /bin/firefox -P OXO "$1" >/dev/null 2>&1 &
[[ $activity == "Development" ]] && /bin/firefox -P DEV "$1" >/dev/null 2>&1 &
[[ $activity == "Main" ]] && /bin/firefox "$1" >/dev/null 2>&1 &
[[ $activity == "Videos" ]] && /bin/firefox "$1" >/dev/null 2>&1 &
