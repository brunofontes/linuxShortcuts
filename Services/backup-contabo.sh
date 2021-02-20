#! /bin/bash
if [[ -z $CONTABO_BACKUP_PATH ]]; then
    echo CONTABO_BACKUP_PATH environment not set
    exit 1
fi
sleep 60
/bin/rsync --archive --exclude "files/nextcloud*" -e "ssh" backupContabo:/home/bruno/backups/* $CONTABO_BACKUP_PATH

# Delete old backups
find $CONTABO_BACKUP_PATH/db -type f -name "*.sql.gz" -mtime +15 -delete
find $CONTABO_BACKUP_PATH/keys -type f -name "*.*" -mtime +15 -delete
find $CONTABO_BACKUP_PATH/files -type f -name "*.*" -mtime +35 -delete
find $CONTABO_BACKUP_PATH/mail -type f -name "*.*" -mtime +20 -delete

find $CONTABO_BACKUP_PATH/ -type f -name "*.*" -mtime +120 -delete
