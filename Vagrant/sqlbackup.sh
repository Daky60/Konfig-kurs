#!/bin/bash

#Takes backup of $SQL_DB every day at 5 am
sudo mysqldump --defaults-extra-file="/tmp/backup.cnf" --no-tablespaces lab_db > "/tmp/backups/lab_db-backup-$(date +%Y-%m-%d)".sql

#removes backups older than 7 days
sudo find /tmp/backups -mtime +7 -type f -delete