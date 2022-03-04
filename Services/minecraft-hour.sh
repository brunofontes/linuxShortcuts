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

BACKUPDIR="/home/bruno/Backups/Minecraft-borg"
SERVERDIR="/home/bruno/Apps/Minecraft"
PUBLICDIR="$SERVERDIR/BedrockServer_Public_19132"
SURVIVALDIR="$SERVERDIR/BedrockServer_Survival_19132"
CREATIVEDIR="$SERVERDIR/BedrockServer_Creative_19134"
PATHTOBACKUP=""
LogFile="log.txt"

BACKUPDATE=$(date +"%Y-%m-%d_%H-%M-%S")

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
            notify-send "Error backuping Public world"
            echo "Error Public $timeout"
            exit 1
        fi
        (( timeout-- ))
        sleep 1s
        echo $tmeout
        runPublic "^usave query\n"
        finishedPublic=$(tail -n 4 "$PUBLICDIR/$LogFile")
        PATHTOBACKUP="$PATHTOBACKUP \"$PUBLICDIR\""
    done
    echo "Passou Public"
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
    PATHTOBACKUP="$PATHTOBACKUP \"$CREATIVEDIR\""

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
    PATHTOBACKUP="$PATHTOBACKUP \"$SURVIVALDIR\""
fi

[[ $PATHTOBACKUP ]] && borg create --stats --compression auto,zstd,9 "$BACKUPDIR::$BACKUPDATE" "$PATHTOBACKUP"

[[ $publicBackup ]] && runPublic "say ^usave resume\n"
[[ $otherBackup ]] && runSurvival "say ^usave resume\n" && runCreative "say ^usave resume\n"

borg prune --keep-within=3d --keep-hourly=96 --keep-weekly=8 --keep-monthly=6 "$BACKUPDIR"
