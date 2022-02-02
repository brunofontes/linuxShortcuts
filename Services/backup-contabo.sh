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
/bin/rsync --archive --exclude "files/nextcloud*" --rsh=ssh backupContabo:/home/bruno/backups/* $CONTABO_BACKUP_PATH

# Backup OXO
/bin/rsync --archive --rsh=ssh oxo:~/OXOwebsiteBackup.tar.gz ~/Backups/OXOwebsite/`date '+%Y-%m-%d'`_OXOwebsiteBackup.tar.gz

# Backup Gitea
/bin/rsync --archive --rsh=ssh googlemicro:~/ttt/*.zip ~/Backups/gitea/`date '+%Y-%m-%d'`_gitea.zip

# Delete old backups
find $CONTABO_BACKUP_PATH/db -type f -name "*.sql.gz" -mtime +15 -delete
find $CONTABO_BACKUP_PATH/keys -type f -name "*.*" -mtime +15 -delete
find $CONTABO_BACKUP_PATH/files -type f -name "*.*" -mtime +35 -delete
find $CONTABO_BACKUP_PATH/mail -type f -name "*.*" -mtime +20 -delete

find $CONTABO_BACKUP_PATH/ -type f -name "*.*" -mtime +120 -delete

find ~/Backups/OXOwebsite/ -type f -name "*.sql.gz" -mtime +15 -delete
