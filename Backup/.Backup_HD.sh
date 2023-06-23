# Ansi color code variables
red="\e[0;91m"
blue="\e[0;94m"
expand_bg="\e[K"
blue_bg="\e[0;104m${expand_bg}"
red_bg="\e[0;101m${expand_bg}"
green_bg="\e[0;102m${expand_bg}"
green="\e[0;92m"
white="\e[0;97m"
bold="\e[1m"
uline="\e[4m"
reset="\e[0m"

function backup () {
    # $1 - Repository
    # $2 - Backup name
    # $3 - Files/Folders to backup
    prepareFolder $1
    DS=$(diskSpace $1)
    echo -e "${blue}            `date +%r` - Backing up (compressed)...${reset} [Free disk space: $DS ]"
    ionice -c 3 nice -n 19 borg create --compression auto,zstd,9 --exclude-from=./exclude "$1::$2" "$3"
    checkBackup $1
}

function backupNoCompression () {
    # $1 - Repository
    # $2 - Backup name
    # $3 - Files/Folders to backup
    prepareFolder $1
    echo -e "${blue}            `date +%r` - Backing up (uncompressed)...${reset}"
    ionice -c 3 nice -n 19 borg create --compression none --exclude-from=./exclude "$1::$2" "$3"
    checkBackup $1
}

function prepareFolder() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        borg init --encryption=none $1
    else
        pruneBackup $1
    fi
}

function checkBackup() {
    echo -e -n "${blue}            `date +%r` - Checking the backup...${reset}"
    borg check "$1" > "$1"_status
    if [[ $(cat "$1"_status) != "" ]]; then
        echo -e "\n\033[1;31m ERROR UNPACKING $1 \033[0m"
    else
        echo -e ".${green}OK!${reset}"
        rm "$1"_status
    fi
    echo
}

function pruneBackup() {
    echo -e "${blue}            `date +%r` - Prune old backups...${reset}"
    borg prune --keep-weekly=4 --keep-monthly=12 --keep-yearly=1 $1
    borg compact $1
}

function diskSpace() {
    df -h --output=avail "$1" | sed --silent '2p'
}

cd /home/bruno/Apps/linuxShortcuts/Backup/

LastDisk=$(< .lastDisk)
if [ "$LastDisk" = '1' ]; then
    ActiveDisk=2
else
    ActiveDisk=1
fi

YEAR=`date +%Y`
HDPath="/run/media/bruno/Backup_$ActiveDisk"

BACKUPPATH="$HDPath/Backup"
YEARMONTH=`date +%Y-%m-%d`

echo
echo "Disk              : $ActiveDisk"
echo "HD Backup path    : $BACKUPPATH"
echo
echo "Please, insert Disk #$ActiveDisk and press enter to start backup"
read

timeout=30
echo -n "Mounting Backup_$ActiveDisk"
mount $HDPath
device=$(mount | grep "Backup_$ActiveDisk" | cut -d " " -f1)
while [[ "$device" != *"/dev/"* ]]; do
    [[ $timeout -lt 1 ]] && echo -e "\e[97m Timeout!\e[39m" && exit 1
    (( timeout-- ))
    echo -n "."
    sleep 1s
    device=$(mount | grep "Backup_$ActiveDisk" | cut -d " " -f1)
done

# If folder does not exist, exit with error
[ ! -d "$HDPath" ] && echo "This disk was used last time. Please, plug Backup_$ActiveDisk before running this script." && read && exit 1
echo -e ".${green}OK!${reset}"
echo

echo -e "${white}`date +%r` - Copying Linux Home folder (1/7)...\e[39m"
echo -e "${white}            `date +%r` - Bruno\e[39m"
backup "$HDPath/LinuxHome-Bruno" "$YEARMONTH" "/home/bruno/" || echo ""

echo -e "${white}            `date +%r` - Admin\e[39m"
backup "$HDPath/LinuxHome-Admin" "$YEARMONTH" "/home/admin/" || echo ""

echo -e "${white}`date +%r` - Copying Localização folder (2/7)...\e[39m"
backup "$HDPath/Multimedia-Localizacao" "$YEARMONTH" "/run/media/bruno/Multimedia/Localização/" || echo ""

echo -e "${white}`date +%r` - Copying My Documents folder (3/7)...\e[39m"
backup "$HDPath/Multimedia-MyDocuments" "$YEARMONTH" "/run/media/bruno/Multimedia/MyDocuments/" || echo ""

echo -e "${white}`date +%r` - Copying Música folder (4/7)...\e[39m"
backup "$HDPath/Multimedia-Musica" "$YEARMONTH" "/run/media/bruno/Multimedia/Música/" || echo ""

echo -e "${white}`date +%r` - Copying Fotos folder (5/7)...\e[39m"
backupNoCompression "$HDPath/Fotos" "$YEARMONTH" "/run/media/bruno/Multimedia/Fotos" || echo ""

echo -e "${white}`date +%r` - Copying Video folder (6/7)...\e[39m"
backupNoCompression "$HDPath/Videos" "$YEARMONTH" "/run/media/bruno/Multimedia/Videos" || echo ""

#echo -e "${white}`date +%r` - Copying Virtual Machines folder (7/7)...\e[39m"
#backup "$HDPath/VirtualMachines" "$YEARMONTH" "/run/media/bruno/Multimedia/Virtual Machines" || echo ""

# Show result
echo -e "${green}`date +%r` - Backup finished. Please, verify your log files.\e[39m"

echo "$ActiveDisk" > .lastDisk

# /usr/bin/curl -d "Backup HD: Completed" ntfy.sh/bft >/dev/null 2>&1 &
/home/bruno/Apps/linuxShortcuts/ntfy.sh -t "Michelle Backup Completed!" a "floppy_disk" "Close the window and remove the disk..." >/dev/null 2>&1 &
kdialog --title "Backup Complete" --msgbox "Backup finished successfully"
echo
echo "Backup on $device is finished. Press any key to close..."
read

#Try to umount device
udisksctl unmount -b "$device" && udisksctl power-off -b "$device"
exit
