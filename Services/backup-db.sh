#! /bin/bash
sleep 50
sshKey=$(<.sshKey)
serverBackupPath=$(<.serverBackupPath)
localPath=$(<.localBackupPath)

/bin/rsync -r -e "ssh -i $sshKey" "$serverBackupPath/db/*" "$localPath/db/"

# Delete files older than 15 days
find "$localPath/db" -type f -name "*.sql.gz" -mtime +15 -delete
