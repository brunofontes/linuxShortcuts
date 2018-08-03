YEARMONTH=`date +%Y/%m-%b`
YEAR=`date +%Y`
HDPath="/run/media/bruno/Seagate\ Expansion\ Drive"
HDYEARMONTH="$HDPath/$YEARMONTH"

mkdir -p "$HDPath/$YEAR"
mkdir -p "$HDYEARMONTH"
mkdir -p "$HDYEARMONTH/LinuxHome"
mkdir -p "$HDYEARMONTH/LinuxHome/bruno"
mkdir -p "$HDYEARMONTH/LinuxHome/admin"
mkdir -p "$HDYEARMONTH/LinuxHome/lost+found"

backup="rsync -rptgoDql --exclude-from=./exclude"

echo
echo "Backup command    : $backup"
echo "HD Backup path    : $HDPath"
echo "HD Year-Month path: $HDYEARMONTH"
echo
echo Press enter key to start the backup
read
echo

echo -e "\e[97m`date +%r` - Copying Dropbox folder (1/7)...\e[39m"
eval $backup "/run/media/bruno/Multimedia/Dropbox" "$HDYEARMONTH/Multimedia/" || echo ""

echo -e "\e[97m`date +%r` - Copying Linux Home folder (2/7)...\e[39m"

echo -e "\e[97m            `date +%r` - Bruno\e[39m"
eval $backup "/home/bruno/" "$HDYEARMONTH/LinuxHome/bruno/" || echo ""

echo -e "\e[97m            `date +%r` - Admin\e[39m"
eval $backup "/home/admin/" "$HDYEARMONTH/LinuxHome/admin/" || echo ""

echo -e "\e[97m`date +%r` - Copying Localização folder (3/7)...\e[39m"
eval $backup "/run/media/bruno/Multimedia/Localização" "$HDYEARMONTH/Multimedia/" || echo ""

echo -e "\e[97m`date +%r` - Copying My Documents folder (4/7)...\e[39m"
eval $backup "/run/media/bruno/Multimedia/My\ Documents" "$HDYEARMONTH/Multimedia/" || echo ""

echo -e "\e[97m`date +%r` - Copying Música folder (5/7)...\e[39m"
eval $backup "/run/media/bruno/Multimedia/Música" "$HDYEARMONTH/Multimedia/" || echo ""

echo -e "\e[97m`date +%r` - Copying Fotos folder (6/7)...\e[39m"
eval $backup "/run/media/bruno/Multimedia/Fotos" "$HDPath/$YEAR/" || echo ""

echo -e "\e[97m`date +%r` - Copying Virtual Machines folder (7/7)...\e[39m"
eval $backup "/run/media/bruno/Multimedia/Virtual\ Machines" "$HDPath/$YEAR/" || echo ""

echo -e "\e[97m`date +%r` - Backup finished. Please, verify your log files.\e[39m"

kdialog --title "Backup Complete" --msgbox "Backup finished successfully"

echo 
echo Press enter key to close
read

