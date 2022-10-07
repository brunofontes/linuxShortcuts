#!/bin/sh
sleep 2s
[ -z $* ] && /home/bruno/Apps/linuxShortcuts/music/csound --analog
killall OXO.sh >/dev/null
killall lockOXO.sh >/dev/null
tomatos=`ps aux | grep tomatoshell | awk '{ print $11 " " $12 " " $13 " " $14 }'`
for tomato in tomatos; do
    pkill --signal SIGINT -f "$tomato"
done
