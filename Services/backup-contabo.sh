#! /bin/bash

if [[ `nmcli -t -f GENERAL.METERED dev show | grep "METERED:yes"` ]]; then
    echo Backup does not work on metered connections
    exit 1
fi

if [[ -z $CONTABO_BACKUP_PATH ]]; then
    echo CONTABO_BACKUP_PATH environment not set
    exit 1
fi
sleep 60

# Backup Contabo
/bin/rsync --archive --backup --exclude "files/nextcloud*" --rsh=ssh backupContabo:/home/bruno/backups/* $CONTABO_BACKUP_PATH

# Backup Gitea
/bin/rsync --archive --backup --rsh=ssh bkpgitea:~/ttt/* ~/Backups/gitea/

# Backup OXO Files
/bin/rsync --archive --backup --rsh=ssh oxo:~/public_html ~/Backups/OXOwebsite/
tar cfz ~/Backups/OXOwebsite/`date '+%Y-%m-%d'`_OXOwebsiteBackup.tar.gz ~/Backups/OXOwebsite/public_html/
rm -rf ~/Backups/OXOwebsite/public_html/

# Backup OXO DB
ssh oxo ./backupDB.sh
/bin/rsync --archive --backup --compress --rsh=ssh oxo:~/db/* ~/Backups/OXOwebsite/
ssh oxo rm ./db/*

# Delete old backups
find $CONTABO_BACKUP_PATH/db -type f -name "*.sql.gz" -mtime +15 -delete
find $CONTABO_BACKUP_PATH/keys -type f -name "*.*" -mtime +15 -delete
find $CONTABO_BACKUP_PATH/files -type f -name "*.*" -mtime +35 -delete
find $CONTABO_BACKUP_PATH/mail -type f -name "*.*" -mtime +20 -delete
find $CONTABO_BACKUP_PATH/ -type f -name "*.*" -mtime +120 -delete

find ~/Backups/OXOwebsite/ -type f -name "*.gz" -mtime +15 -delete
find ~/Backups/gitea/ -type f -name "*.zip" -mtime +15 -delete
