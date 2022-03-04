#!/bin/zsh
cd /run/media/bruno/Multimedia/MyDocuments/Development/projetomovase
if [[ $(tmux ls | grep 'pmovase') ]]; then
    terminator -T PMova-se -b --geometry=627x927 -x tmux a -t pmovase &
    exit
fi

echo "Iniciando Vagrant..."
tmux new -d -s pmovase

tmux splitw -t pmovase
tmux splitw -t pmovase
tmux splitw -t pmovase
tmux splitw -h -t pmovase:0.1

terminator -T PMova-se -b --geometry=627x927 -x tmux a -t pmovase &

tmux resize-pane -t pmovase:0.0 -U 35
tmux resize-pane -t pmovase:0.1 -U 10
tmux resize-pane -t pmovase:0.4 -U 10

tmux send -t pmovase:0.0 $'npm run vagrant; npm run watch\n'
tmux send -t pmovase:0.2 $'clear; echo Waiting for vagrant to start...\n'

while [[ -z $(ping projetomovase.test -c 1 | grep "time=") ]] ; do
    sleep 5
done
sleep 10

tmux send -t pmovase:0.1 $'npm run cypress:open\n'
tmux send -t pmovase:0.1 $'npm run test-watch\n'
tmux send -t pmovase:0.2 $'^u'
tmux send -t pmovase:0.2 $'npm run test-php-watch\n'
tmux send -t pmovase:0.3 $'npm run ssh\n'
tmux send -t pmovase:0.4 $'alias clear=\'clear;figlet PMova-se\';clear\n'

/bin/vscodium &
/home/bruno/Apps/firefox/firefox-bin &
