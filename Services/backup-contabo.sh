#! /bin/bash
sleep 60
/bin/rsync -a -e "ssh -i /home/bruno/.ssh/id_rsa_backup" mybackup@167.86.78.36:/home/bruno/backups/* /home/bruno/Backups/Contabo/

# Delete old backups
find /home/bruno/Backups/Contabo/db -type f -name "*.sql.gz" -mtime +15 -delete
find /home/bruno/Backups/Contabo/files -type f -name "*.*" -mtime +35 -delete
find /home/bruno/Backups/Contabo/vmail -type f -name "*.*" -mtime +20 -delete

find /home/bruno/Backups/Contabo/ -type f -name "*.*" -mtime +120 -delete
