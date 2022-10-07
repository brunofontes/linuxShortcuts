#!/bin/sh
cd /home/bruno/Apps/piholeDocker
docker-compose exec pihole tail -f /var/log/pihole.log | awk '/from/ { printf("%s %2s %s %40s %s\n", $1, $2, $3, $6, $8 ) }'
