if ! screen -list | grep -q "minecraftPE"; then
  exit 1
fi

function runAllWorlds () {
    screen -S minecraftPESurvival -X stuff "$1"
    screen -S minecraftPECreative -X stuff "$1"
}

runAllWorlds "say $(date +%l:%M)\n"

HORA=$(date +%H)
if [ "$HORA" -ge 23 ]; then
    screen -S minecraftPECreative -X stuff $'say Hora de dormir\n'
    sleep 5
    screen -S minecraftPECreative -X stuff $'stop\n'

    if [ "$HORA" -ge 1 -a "$HORA" -lt 5 ]; then
        screen -S minecraftPESurvival -X stuff $'say Hora de dormir\n'
        source /home/bruno/Apps/Minecraft/stopServers.sh
    fi

fi
