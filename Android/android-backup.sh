
time adb backup -apk -shared -all -f /run/media/bruno/Multimedia/My\ Backups/android_backup.ab && kdialog --title "Android Backup Complete" --msgbox "Android Backup finished successfully"
echo
ls -lh /run/media/bruno/Multimedia/My\ Backups/android_backup.ab | gawk '{ printf $5 " "; for(i=6;i<=NF;i++) printf $i " "; print "\n" }'
