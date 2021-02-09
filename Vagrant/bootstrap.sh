#!/bin/bash

# update stuff
apt-get update
apt-get upgrade

## db variables
SQL_DB=lab_db
SQL_USER=labuser
SQL_PWD=labpw

## install lamp stack
sudo apt-get install -y apache2
sudo apt-get install -y mysql-server libapache2-mod-php php-mysql php

## Create new index.html file
sudo mv /var/www/html/index.html /var/www/html/index.html.old
echo "Hi $USER" | sudo tee /var/www/html/index.html > /dev/null

## create db & user etc
sudo mysql << EOF
create database $SQL_DB;
use $SQL_DB;
create user $SQL_USER identified by '$SQL_PWD';
grant select, show view, trigger, lock tables on $SQL_DB.* to '$SQL_USER';
EOF

## create cnf file
printf "[mysqldump]\nuser = %s\npassword = %s\n" "$SQL_USER" "$SQL_PWD" | sudo tee /tmp/backup.cnf > /dev/null

## Add cronjob etc
sudo mkdir /tmp/backups
echo "0 5 * * *    bash     /usr/local/sbin/sqlbackup.sh" | sudo tee /usr/local/sbin/crontab > /dev/null
sudo mv /tmp/sqlbackup.sh /usr/local/sbin/sqlbackup.sh
sudo chmod +x /usr/local/sbin/sqlbackup.sh
sudo crontab /usr/local/sbin/crontab