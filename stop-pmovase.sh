#!/bin/zsh
#if [[ !$(tmux ls | grep 'pmovase') ]]; then
#    exit
#fi

killall /home/bruno/Apps/firefox/firefox-bin
killall /bin/vscodium

cd /home/bruno/development/projetomovase/
vagrant suspend
tmux send -t pmovase:0.4 $'^u'
#tmux send -t pmovase:0.4 $'vagrant suspend &\n'
tmux kill-session -t pmovase
