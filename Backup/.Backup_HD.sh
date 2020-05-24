LastDisk=$(< .lastDisk)
if [ "$LastDisk" = '1' ]; then
    ActiveDisk=2
else
    ActiveDisk=1
fi

YEAR=`date +%Y`
HDPath="/run/media/bruno/Backup_$ActiveDisk"

ZBACKUP="$HDPath/`date +%Y-Q%q`"
YEARMONTH=`date +%m_%b-%d`
HDYEARMONTH="$ZBACKUP/backups/$YEARMONTH"


# If folder does not exist, exit with error
[ ! -d "$HDPath" ] && echo "This disk was used last time. Please, plug Backup_$ActiveDisk before running this script." && read && exit 1

echo
echo "HD Backup path    : $ZBACKUP"
echo "HD Year-Month path: $HDYEARMONTH"
echo
echo Press enter key to start the backup
read
echo

if [ ! -d "$ZBACKUP" ]; then
    mkdir -p "$ZBACKUP"
    zbackup init --non-encrypted "$ZBACKUP"

    #If diskSpace less than ~100GB...
    diskSpace=$(df --local --output=avail,target | grep "$HDPath\$" | awk '{ print $1}')
    if [[ "$diskSpace" < 100000000 ]]; then
        # delete oldest backup folder
        oldestFolder=$(/bin/ls -dt "$HDPath"/????-Q? | tail -n 1)
        echo
        echo "$HDPath/$oldestFolder"
        rm -rI "$HDPath/$oldestFolder"
    fi
fi

mkdir -p "$HDYEARMONTH"

function backup () {
    nice -n 19 tar c --exclude-ignore=.no-backup --add-file=.backup --exclude-from=./exclude "$1" | zbackup backup --non-encrypted --silent "$2"
    zbackup restore --silent --non-encrypted "$2" > /dev/null 2> "$2"_status
    if [[ $(cat "$2"_status) != "" ]]; then
        echo -e "\033[1;31m ERROR UNPACKING $2 \033[0m"
    fi
}

echo -e "\e[97m`date +%r` - Copying Linux Home folder (1/7)...\e[39m"
echo -e "\e[97m            `date +%r` - Bruno\e[39m"
backup "/home/bruno/" "$HDYEARMONTH/LinuxHome-bruno" || echo ""

echo -e "\e[97m            `date +%r` - Admin\e[39m"
backup "/home/admin/" "$HDYEARMONTH/LinuxHome-admin" || echo ""

echo -e "\e[97m            `date +%r` - Lost+Found\e[39m"
backup "/home/lost+found/" "$HDYEARMONTH/LinuxHome-lost+found" || echo ""

echo -e "\e[97m`date +%r` - Copying Localização folder (2/7)...\e[39m"
backup "/run/media/bruno/Multimedia/Localização/" "$HDYEARMONTH/Multimedia-localizacao" || echo ""

echo -e "\e[97m`date +%r` - Copying My Documents folder (3/7)...\e[39m"
backup "/run/media/bruno/Multimedia/MyDocuments/" "$HDYEARMONTH/Multimedia-MyDocuments" || echo ""

echo -e "\e[97m`date +%r` - Copying Música folder (4/7)...\e[39m"
backup "/run/media/bruno/Multimedia/Música/" "$HDYEARMONTH/Multimedia-musica" || echo ""


# Rsync Fotos e VMs
alias myrsync='nice -n 19 rsync -a'

echo -e "\e[97m`date +%r` - Copying Fotos folder (5/7)...\e[39m"
myrsync "/run/media/bruno/Multimedia/Fotos" "$HDPath/$YEAR/" || echo ""

echo -e "\e[97m`date +%r` - Copying Video folder (6/7)...\e[39m"
myrsync --exclude-from=/run/media/bruno/Multimedia/Videos/.no-backup "/run/media/bruno/Multimedia/Videos" "$HDPath/$YEAR/" || echo ""

echo -e "\e[97m`date +%r` - Copying Virtual Machines folder (7/7)...\e[39m"
myrsync "/run/media/bruno/Multimedia/Virtual Machines" "$HDPath/$YEAR/" || echo ""


# Show result
echo -e "\e[97m`date +%r` - Backup finished. Please, verify your log files.\e[39m"

echo "$ActiveDisk" > .lastDisk    
device=$(mount | grep "Backup_$ActiveDisk" | cut -d " " -f1)

kdialog --title "Backup Complete" --msgbox "Backup finished successfully"
echo
echo "Backup on $device is finished. Press any key to close..."
read


#Try to umount device
udisksctl unmount -b "$device" && udisksctl power-off -b "$device"
exit
