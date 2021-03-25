if [ $1 ]; then
    sudo borg list $1
else
    echo
    echo "ERROR: Backup folder argument is missing. Use folder name to display backup set or FOLDER_NAME::BACKUP_SET to display files."
    echo
fi
