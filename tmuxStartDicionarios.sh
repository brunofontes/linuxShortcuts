#!/bin/zsh

projectName=dicionarioscc
cd /run/media/bruno/Multimedia/MyDocuments/Development/BrunoFontes/dicionarios.cc/
if [[ $(tmux ls | grep '$projectName') ]]; then
    uxterm -T $projectName -geometry 627x927 -e tmux a -t $projectName &
    exit
fi

tmux new -d -s $projectName

tmux splitw -ht $projectName
tmux splitw -vt $projectName:0.1
tmux splitw -vt $projectName:0.2

uxterm -T $projectName -geometry 627x927 -e tmux a -t $projectName &

tmux send -t $projectName:0.0 $'nvim\n'
tmux send -t $projectName:0.1 $'make dev\n'
tmux send -t $projectName:0.2 $'tail -f src/dicio.log\n'
tmux send -t $projectName:0.3 $'gss\n'
