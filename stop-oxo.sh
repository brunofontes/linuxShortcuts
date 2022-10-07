#!/bin/bash
tmux kill-session -t Pomodoro
pkill "/usr/lib/firefox/firefox -P OXO"
pkill teams
kactivities-cli --stop-activity `kactivities-cli --list-activities | grep "OXO" | cut -d' ' -f2`
