#! /bin/bash
sleep 60
sshKey=$(<.sshKey)
serverBackupPath=$(<.serverBackupPath)
localPath=$(<.localBackupPath)

/bin/rsync -r -e "ssh -i $sshKey" "$serverBackupPath/files/*" "$localPath/files/"

# Delete files older than 30 days
find "$localPath/files" -type f -name "*.*" -mtime +30 -delete
