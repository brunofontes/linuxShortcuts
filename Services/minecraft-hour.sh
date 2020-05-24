if ! screen -list | grep -q "Minecraft"; then
  exit 1
fi

BACKUPDIR="/home/bruno/Backups/zBackup-Minecraft/backups"
SERVERDIR="/home/bruno/Apps/Minecraft"
SURVIVALDIR="$SERVERDIR/BedrockServer_Survival_19132"
CREATIVEDIR="$SERVERDIR/BedrockServer_Creative_19134"
LogFile="log.txt"

alias run='screen -S Minecraft -X'
alias runSurvival='run at Survival stuff'
alias runCreative='run at Creative stuff'
alias runAllWorlds='run at "#" stuff'

cd /home/bruno/Apps/Minecraft

runAllWorlds "^u"
runAllWorlds "say $(date +%l:%M) - Saving worlds\n"
runAllWorlds "save hold\n"
sleep 2s

finishedCreative=""
timeout=30
while [[ $finishedCreative != *"Data saved."* ]]; do
    if [[ $timeout -lt 1 ]]; then
        notify-send "Error backuping Creative world"
        exit 1
    fi
    (( timeout-- ))
    sleep 1s
    runCreative "^u"
    runCreative "save query\n"
    finishedCreative=$(tail -n 4 "$CREATIVEDIR/$LogFile")
done

timeout=30
finishedSurvival=""
while [[ $finishedSurvival != *"Data saved."* ]]; do
    if [[ $timeout -lt 1 ]]; then
        notify-send "Error backuping Survival world"
        exit 1
    fi
    (( timeout-- ))
    sleep 1s
    runSurvival "^u"
    runSurvival "save query\n"
    finishedSurvival=$(tail -n 4 "$SURVIVALDIR/$LogFile")
done

BACKUPDATE=$(date +"%Y-%m-%d_%H-%M-%S")
mkdir "$BACKUPDIR/$BACKUPDATE"
/bin/tar c --exclude=behavior_packs/* --exclude=resource_packs/* "$SURVIVALDIR/worlds/Survival" | zbackup --nonencrypted backup "$BACKUPDIR/$BACKUPDATE-Survival" 
/bin/tar c --exclude=behavior_packs/* --exclude=resource_packs/* "$CREATIVEDIR/worlds/Creative" | zbackup --nonencrypted backup "$BACKUPDIR/$BACKUPDATE-Creative" 

runAllWorlds "^u"
runAllWorlds "save resume\n"
