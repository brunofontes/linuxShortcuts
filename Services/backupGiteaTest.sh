#! /bin/bash
# Backup Gitea
/bin/rsync --archive --backup --rsh=ssh bkpgitea:~/ttt/* ~/Backups/gitea/
