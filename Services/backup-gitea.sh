#!/usr/bin/env bash
cd /home/brunofontes/ttt/
sudo -u git GITEA_WORK_DIR=/var/lib/gitea/ /usr/local/bin/gitea dump -c /etc/gitea/app.ini
chown brunofontes:brunofontes *.zip
find ./ -type f -name "*.zip" -mtime +2 -delete
