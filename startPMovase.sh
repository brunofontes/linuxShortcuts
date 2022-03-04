cd /run/media/bruno/Multimedia/MyDocuments/Development/projetomovase
if [[ $(screen -ls | grep 'pmovase') ]]; then
    echo "Já está rodando, saindo..."
    exit
fi
echo "Iniciando Vagrant..."
screen -dmS pmovase
screen -S pmovase -p 0 -X stuff $'npm run vagrant; npm run watch\n'
screen -S pmovase -X screen
screen -S pmovase -X screen
sleep 2s
screen -S pmovase -p 2 -X title $'GIT'

sleep 2m
screen -S pmovase -p 0 -X title $'NPM WATCH\n'
screen -S pmovase -p 1 -X stuff $'npm run ssh\n'
sleep 5s
screen -S pmovase -p 1 -X title $'Artisan'

screen -S pmovase -X select 2
screen -S pmovase -p 1 -X echo $'Done!\n'
screen -S pmovase -p 2 -X echo $'Done!\n'

echo "Screen running. Attach to it with 'screen -r pmovase'"
