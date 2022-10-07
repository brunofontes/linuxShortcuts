#!/bin/sh
/usr/bin/nextcloud --background &
sleep 5
/home/bruno/Apps/linuxShortcuts/start-dashboard &
sleep 5
/home/bruno/Apps/remoteControl/start-remotecontrol.sh &
sleep 5
/home/bruno/.local/bin/obs-virtWebcam &
sleep 5
DISPLAY=0 firefox
