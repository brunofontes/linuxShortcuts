#! /bin/bash

set +e

if [[ `nmcli -t -f GENERAL.METERED dev show | grep "METERED:yes"` ]]; then
    echo Backup does not work on metered connections
    exit 1
fi

if [[ -z $CONTABO_BACKUP_PATH ]]; then
    echo CONTABO_BACKUP_PATH environment not set
    exit 1
fi
sleep 60

ntfy="/home/bruno/Apps/linuxShortcuts/ntfy.sh --title Backup"
OXO_PATH="/home/bruno/Backups/OXOwebsite/"

# Backup Contabo
echo "Backuping Contabo..."
ntfy "Starting Contabo..."
/bin/rsync --archive --backup --exclude "files/nextcloud*" --rsh=ssh backupContabo:/home/bruno/backups/* $CONTABO_BACKUP_PATH

# Backup Gitea
echo "Backuping Gitea..."
ntfy "Starting GoogleMicro..."
/bin/rsync --archive --backup --rsh=ssh bkpgitea:/home/brunofontes/ttt/ /home/bruno/Backups/gitea/

# Backup OXO Files
echo "Backuping OXO Files..."
/bin/rsync --archive --backup --exclude='uploads/cf7-uploads-custom/' --rsh=ssh oxo:~/public_html $OXO_PATH

DATE=$(date '+%Y-%m-%d')

echo "Borg(ing) OXO Files..."
ionice -c 3 nice -n 19 borg create --compression auto,zstd,9 --exclude-from="${OXO_PATH}.exclude" "${OXO_PATH}borg::${DATE}_Files" "${OXO_PATH}public_html/"

echo "Deleting already backuped OXO Files..."
rm -rf "${OXO_PATH}public_html/"

# Backup OXO DB
echo "Backuping OXO DBs..."
ssh oxo ./backupDB.sh
/bin/rsync --archive --backup --compress --rsh=ssh oxo:~/db/* $OXO_PATH
ssh oxo rm ./db/*
ionice -c 3 nice -n 19 borg create --compression auto,zstd,9 --exclude-from="${OXO_PATH}.exclude" "${OXO_PATH}borg::${DATE}_DBs" $OXO_PATH
rm -f "${OXO_PATH}*.gz"

# Delete old backups
echo "Deleting old backup files..."
find $CONTABO_BACKUP_PATH/db -type f -name "*.sql.gz" -mtime +15 -delete
find $CONTABO_BACKUP_PATH/keys -type f -name "*.*" -mtime +15 -delete
find $CONTABO_BACKUP_PATH/files -type f -name "*.*" -mtime +35 -delete
find $CONTABO_BACKUP_PATH/mail -type f -name "*.*" -mtime +20 -delete
find $CONTABO_BACKUP_PATH/ -type f -name "*.*" -mtime +120 -delete

find /home/bruno/Backups/gitea/ -type f -name "*.zip" -mtime +15 -delete
ntfy "Websites Backup Finished"
