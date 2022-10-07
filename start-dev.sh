#!/bin/sh
kactivities-cli --set-current-activity `kactivities-cli --list-activities | grep "Development" | cut -d' ' -f2`
/bin/terminator --title "DEV" -x "cd ~/development; tmux new -t \"DEV\"" &
/bin/qutebrowser &>/dev/null &
sleep 4

TERMINATOR="0,1988,61,1760,880"
QUTE="0,90,78,1715,900"
wmctrl -r "DEV" -F -b remove,maximized_vert,maximized_horz
wmctrl -r "qutebrowser" -b remove,maximized_vert,maximized_horz
sleep 1
wmctrl -r "DEV" -F -e $TERMINATOR
wmctrl -r "qutebrowser" -e $QUTE
