#!/bin/bash
zenity --question --text="Should I stop OXO activity?" || exit 0
tmux kill-session -t Pomodoro
pkill "/usr/lib/firefox/firefox -P OXO"
pkill "brave"
pkill teams
kactivities-cli --stop-activity `kactivities-cli --list-activities | grep "OXO" | cut -d' ' -f2`
