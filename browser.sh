#!/bin/sh
activity=`kactivities-cli --current-activity | cut -d" " -f3`

[[ $activity == "OXO" ]] && /bin/brave "$1"
[[ $activity == "Development" ]] && /home/bruno/Apps/firefox/firefox-bin "$1"
[[ $activity == "Main" ]] && /bin/firefox "$1"
[[ $activity == "Videos" ]] && /bin/firefox "$1"
