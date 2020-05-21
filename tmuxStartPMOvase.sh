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

tmux resize-pane -t pmovase:0.0 -U 30
tmux resize-pane -t pmovase:0.1 -U 15
tmux resize-pane -t pmovase:0.4 -U 10

tmux send -t pmovase:0.0 $'npm run vagrant; npm run watch\n'
tmux send -t pmovase:0.2 $'clear; Waiting for vagrant to start...\n'

while [[ -z $(ping projetomovase.test -c 1 | grep "time=") ]] ; do
    sleep 1
done

tmux send -t pmovase:0.1 $'npm run test-watch\n'
tmux send -t pmovase:0.2 $'^u'
tmux send -t pmovase:0.2 $'phpunit-watcher watch\n'
tmux send -t pmovase:0.3 $'ssh homestead -t \"cd code;clear; figlet Vagrant;bash --login\"\n'
tmux send -t pmovase:0.4 $'clear;figlet PMova-se\n'

