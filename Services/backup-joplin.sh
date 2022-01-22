#!/bin/bash

BACKUP_DIR="/home/bruno/Backups/Joplin"
JOPLIN_BIN="/usr/bin/joplin"

$JOPLIN_BIN sync
$JOPLIN_BIN e2ee decrypt

# Delete old backups
cd "$BACKUP_DIR"
rm -r "./joplin.jex"
rm -rf "./MD"

$JOPLIN_BIN --log-level debug export --format jex "$BACKUP_DIR/joplin.jex"
$JOPLIN_BIN --log-level debug export --format md "$BACKUP_DIR/MD"
