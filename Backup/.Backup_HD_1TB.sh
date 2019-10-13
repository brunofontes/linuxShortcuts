YEARMONTH=`date +%Y/%m-%b`
YEAR=`date +%Y`
HDPath="/run/media/bruno/Backup_"
LastDisk=$(< .lastDisk)

if [ "$LastDisk" = '1' ]; then
    NextDisk=2
else
    NextDisk=1
fi

#backup="rsync -aq --inplace --exclude-from=./exclude"
backup="nice -n 19 rsync -a --exclude-from=./exclude"
HDPath="$HDPath$NextDisk"
HDYEARMONTH="$HDPath/$YEARMONTH"

# If folder does not exist, exit with error
[ ! -d "$HDPath" ] && echo "This disk was used last time. Please, plug Backup_$NextDisk before running this script." && exit 1

echo
echo "Backup command    : $backup"
echo "HD Backup path    : $HDPath"
echo "HD Year-Month path: $HDYEARMONTH"
echo
echo Press enter key to start the backup
read
echo

mkdir -p "$HDPath/$YEAR"
mkdir -p "$HDYEARMONTH"
mkdir -p "$HDYEARMONTH/LinuxHome"
mkdir -p "$HDYEARMONTH/LinuxHome/bruno"
mkdir -p "$HDYEARMONTH/LinuxHome/admin"
mkdir -p "$HDYEARMONTH/LinuxHome/lost+found"


echo -e "\e[97m`date +%r` - Copying Dropbox folder (1/7)...\e[39m"
eval $backup "/run/media/bruno/Multimedia/Dropbox" "$HDYEARMONTH/Multimedia/" || echo ""

echo -e "\e[97m`date +%r` - Copying Linux Home folder (2/7)...\e[39m"

echo -e "\e[97m            `date +%r` - Bruno\e[39m"
eval $backup "/home/bruno/" "$HDYEARMONTH/LinuxHome/bruno/" || echo ""

echo -e "\e[97m            `date +%r` - Admin\e[39m"
eval $backup "/home/admin/" "$HDYEARMONTH/LinuxHome/admin/" || echo ""

echo -e "\e[97m            `date +%r` - Lost+Found\e[39m"
eval $backup "/home/lost+found/" "$HDYEARMONTH/LinuxHome/lost+found/" || echo ""

echo -e "\e[97m`date +%r` - Copying Localização folder (3/7)...\e[39m"
eval $backup "/run/media/bruno/Multimedia/Localização" "$HDYEARMONTH/Multimedia/" || echo ""

echo -e "\e[97m`date +%r` - Copying My Documents folder (4/7)...\e[39m"
eval $backup "/run/media/bruno/Multimedia/MyDocuments" "$HDYEARMONTH/Multimedia/" || echo ""

echo -e "\e[97m`date +%r` - Copying Música folder (5/7)...\e[39m"
eval $backup "/run/media/bruno/Multimedia/Música" "$HDYEARMONTH/Multimedia/" || echo ""

echo -e "\e[97m`date +%r` - Copying Fotos folder (6/7)...\e[39m"
eval $backup "/run/media/bruno/Multimedia/Fotos" "$HDPath/$YEAR/" || echo ""

echo -e "\e[97m`date +%r` - Copying Virtual Machines folder (7/7)...\e[39m"
eval $backup "/run/media/bruno/Multimedia/Virtual\ Machines" "$HDPath/$YEAR/" || echo ""

echo -e "\e[97m`date +%r` - Backup finished. Please, verify your log files.\e[39m"

echo "$NextDisk" > .lastDisk    
kdialog --title "Backup Complete" --msgbox "Backup finished successfully"
