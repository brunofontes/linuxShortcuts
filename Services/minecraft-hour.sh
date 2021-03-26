if screen -list | grep -q "MncftPublic"; then
    publicBackup="true"
fi
if screen -list | grep -q "Minecraft"; then
    otherBackup="true"
fi

if [[ -z $publicBackup && -z $otherBackup ]] ; then
    echo "Minecraft is not running. Exiting..."
    exit 0
fi

BACKUPDIR="/home/bruno/Backups/zBackup-Minecraft/backups"
SERVERDIR="/home/bruno/Apps/Minecraft"
PUBLICDIR="$SERVERDIR/BedrockServer_Public_19132"
SURVIVALDIR="$SERVERDIR/BedrockServer_Survival_19132"
CREATIVEDIR="$SERVERDIR/BedrockServer_Creative_19134"
LogFile="log.txt"

BACKUPDATE=$(date +"%Y-%m-%d_%H-%M-%S")
mkdir "$BACKUPDIR/$BACKUPDATE"

alias run='screen -S Minecraft -X'
alias runSurvival='run at Survival stuff'
alias runCreative='run at Creative stuff'
alias runPublic='screen -S MncftPublic -X at Server stuff'
alias runAllWorlds='run at "#" stuff'

cd /home/bruno/Apps/Minecraft

runAllWorlds "^u"
# runAllWorlds "say $(date +%l:%M) - Saving worlds\n"
runPublic "say ^usave hold\n"
runAllWorlds "^usave hold\n"
sleep 2s


if [[ $publicBackup ]]; then
    echo Preparing public
    finishedPublic=""
    timeout=30
    while [[ $finishedPublic != *"Data saved."* ]]; do
        if [[ $timeout -lt 1 ]]; then
            notify-send "Error backuping Creative world"
            exit 1
        fi
        (( timeout-- ))
        sleep 1s
        runPublic "say ^usave query\n"
        finishedPublic=$(tail -n 4 "$PUBLICDIR/$LogFile")
    done
    /bin/tar c "$PUBLICDIR/worlds" | zbackup --non-encrypted backup "$BACKUPDIR/$BACKUPDATE/MncftPublic" 
    runPublic "say ^usave resume\n"
fi

if [[ $otherBackup ]]; then
    echo Preparing others
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
    runCreative "^u"
    runCreative "save resume\n"

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

    /bin/tar c "$SURVIVALDIR/worlds" | zbackup --non-encrypted backup "$BACKUPDIR/$BACKUPDATE/Survival" 
    /bin/tar c "$CREATIVEDIR/worlds" | zbackup --non-encrypted backup "$BACKUPDIR/$BACKUPDATE/Creative" 
    runSurvival "^u"
    runSurvival "save resume\n"
fi

