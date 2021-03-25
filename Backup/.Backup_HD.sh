function backup () {
    # $1 - Repository
    # $2-$N - Files/Folders to backup

    #--stats = show stats at end
    #--progress = show each file being processed
    nice -n 19 borg create --compression auto,zstd,9 --exclude-from=./exclude $*
}

function checkBackup() {
    echo -n "`date +%r`- Checking the backup..."
    borg check "$1" > "$1"_status
    if [[ $(cat "$1"_status) != "" ]]; then
        echo -e "\n\033[1;31m ERROR UNPACKING $1 \033[0m"
    else
        echo ".OK!"
        rm "$1"_status
    fi
    echo
}

function pruneBackup() {
    echo -e "\e[97m`date +%r` - Prune old backups...\e[39m"
    borg prune -v --list --dry-run --keep-weekly=8 --keep-monthly=12 --keep-yearly=3 $1
}


cd /home/bruno/Apps/linuxShortcuts/Backup/

LastDisk=$(< .lastDisk)
if [ "$LastDisk" = '1' ]; then
    ActiveDisk=2
else
    ActiveDisk=1
fi

LastBackupSet=$(< .lastBackupSetDisk_$lastDisk)
if [ "$LastBackupSet" = '1' ]; then
    ActiveBackupSet=2
else
    ActiveBackupSet=1
fi

YEAR=`date +%Y`
HDPath="/run/media/bruno/Backup_$ActiveDisk"

BACKUPPATH="$HDPath/Repository_$ActiveBackupSet"
YEARMONTH=`date +%Y-%m-%d`
HDYEARMONTH="$BACKUPPATH::$YEARMONTH"

echo
echo "Disk              : $ActiveDisk"
echo "HD Backup path    : $BACKUPPATH"
echo "HD Year-Month path: $HDYEARMONTH"
echo
echo "Please, insert Disk #$ActiveDisk and press enter to start backup"
read

timeout=30
echo -n "Mounting Backup_$ActiveDisk"
device=$(mount | grep "Backup_$ActiveDisk" | cut -d " " -f1)
while [[ "$device" != *"/dev/"* ]]; do
    [[ $timeout -lt 1 ]] && echo -e "\e[97m Timeout!\e[39m" && break
    (( timeout-- ))
    echo -n "."
    sleep 1s
    device=$(mount | grep "Backup_$ActiveDisk" | cut -d " " -f1)
done

# If folder does not exist, exit with error
[ ! -d "$HDPath" ] && echo "This disk was used last time. Please, plug Backup_$ActiveDisk before running this script." && read && exit 1
echo ".OK!"
echo

if [ ! -d "$BACKUPPATH" ]; then
    mkdir -p "$BACKUPPATH"
    borg init --encryption=none $BACKUPPATH

    #Prune old backups
    pruneBackup $BACKUPPATH
fi

echo -e "\e[97m`date +%r` - Copying Linux Home folder (1/7)...\e[39m"
echo -e "\e[97m            `date +%r` - Bruno\e[39m"
backup "$HDYEARMONTH-LinuxHome-bruno" "/home/bruno/" || echo ""

echo -e "\e[97m            `date +%r` - Admin\e[39m"
backup "$HDYEARMONTH-LinuxHome-admin" "/home/admin/" || echo ""

echo -e "\e[97m`date +%r` - Copying Localização folder (2/7)...\e[39m"
backup "$HDYEARMONTH-Multimedia-localizacao" "/run/media/bruno/Multimedia/Localização/" || echo ""

echo -e "\e[97m`date +%r` - Copying My Documents folder (3/7)...\e[39m"
backup "$HDYEARMONTH-Multimedia-MyDocuments" "/run/media/bruno/Multimedia/MyDocuments/" || echo ""

echo -e "\e[97m`date +%r` - Copying Música folder (4/7)...\e[39m"
backup "$HDYEARMONTH-Multimedia-musica" "/run/media/bruno/Multimedia/Música/" || echo ""

checkBackup "$BACKUPPATH"

# Rsync Fotos e VMs
echo -e "\e[97m`date +%r` - Copying Fotos folder (5/7)...\e[39m"
nice -n 19 rsync -a "/run/media/bruno/Multimedia/Fotos" "$HDPath/$YEAR/" || echo ""

echo -e "\e[97m`date +%r` - Copying Video folder (6/7)...\e[39m"
nice -n 19 rsync -a --exclude-from=/run/media/bruno/Multimedia/Videos/.no-backup "/run/media/bruno/Multimedia/Videos" "$HDPath/$YEAR/" || echo ""

echo -e "\e[97m`date +%r` - Copying Virtual Machines folder (7/7)...\e[39m"
nice -n 19 rsync -a "/run/media/bruno/Multimedia/Virtual Machines" "$HDPath/$YEAR/" || echo ""

# Show result
echo -e "\e[97m`date +%r` - Backup finished. Please, verify your log files.\e[39m"

echo "$ActiveDisk" > .lastDisk
echo "$ActiveBackupSet" > ".lastBackupSetDisk_$lastDisk"

kdialog --title "Backup Complete" --msgbox "Backup finished successfully"
echo
echo "Backup on $device is finished. Press any key to close..."
read

#Try to umount device
udisksctl unmount -b "$device" && udisksctl power-off -b "$device"
exit
