#!/bin/bash
tmux kill-session -t DEV
pkill qutebrowser
kactivities-cli --stop-activity `kactivities-cli --list-activities | grep "Development" | cut -d' ' -f2`
