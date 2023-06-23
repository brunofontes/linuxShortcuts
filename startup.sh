#!/bin/sh
/usr/bin/nextcloud --background &
sleep 5
/home/bruno/Apps/remoteControl/start-remotecontrol.sh &
sleep 60
/home/bruno/Apps/linuxShortcuts/start-dashboard &

exit 0

#sleep 5
#/home/bruno/.local/bin/obs-virtWebcam &
