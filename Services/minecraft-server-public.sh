if ! screen -list | grep -q "Minecraft"; then
  exit 1
fi

BACKUPDIR="/home/bruno/Backups/zBackup-Minecraft/backups"
SERVERDIR="/home/bruno/Apps/Minecraft/BedrockServer_Public_19132"
LogFile="log.txt"

alias run='screen -S MinecraftPublic -X'
alias runAllWorlds='run at "#" stuff'

runAllWorlds "^u"
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
/bin/tar c "$SURVIVALDIR/worlds" | zbackup --non-encrypted backup "$BACKUPDIR/$BACKUPDATE/Survival" 
/bin/tar c "$CREATIVEDIR/worlds" | zbackup --non-encrypted backup "$BACKUPDIR/$BACKUPDATE/Creative" 

runAllWorlds "^u"
runAllWorlds "save resume\n"
