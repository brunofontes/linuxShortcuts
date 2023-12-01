#!/bin/bash -
PARAM="$1"
LAYOUT=$(</home/bruno/.layout)

kactivities-cli --set-current-activity `kactivities-cli --list-activities | grep "Development" | cut -d' ' -f2`
if [[ -z $(tmux ls | grep "DEV") ]]
then
    /bin/terminator --title "DEV" -x "cd ~/development; tmux new -t \"DEV\"" &
    sleep 1
    opening=1
    startedTerm=1
fi

TERMINATOR="0,1988,61,1760,880"
QUTE="0,90,78,1715,900"
if [ $LAYOUT == "desktop" ]
then
    wmctrl -r "DEV" -F -b remove,maximized_vert,maximized_horz
    wmctrl -r "qutebrowser" -b remove,maximized_vert,maximized_horz
    sleep 1
    wmctrl -r "DEV" -F -e $TERMINATOR
    wmctrl -r "qutebrowser" -e $QUTE
else
    wmctrl -r "DEV" -F -e $TERMINATOR
    wmctrl -r "qutebrowser" -e $QUTE
    sleep 1
    wmctrl -r "DEV" -F -b add,maximized_vert,maximized_horz
    wmctrl -r "qutebrowser" -b add,maximized_vert,maximized_horz
fi


if [[ "$PARAM" ]]
then
    tmux send -t DEV $'cd "'${PARAM}$'"; clear; git status; pwd\n'
else
    [[ -z $startedTerm ]] && exit 0
    tmux send -t DEV $'find $HOME/development/ -maxdepth 2 -type d | gum filter --limit 1 | read myfolder; cd $myfolder; clear; starta . || git status; pwd\n'
fi
