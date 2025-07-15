#!/bin/bash

echo "
FLUSH PRIVILEGES;
CREATE USER IF NOT EXISTS $DB_USER@localhost IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON *.* TO $DB_USER@localhost IDENTIFIED BY '$DB_PASS' WITH GRANT OPTION;
CREATE USER IF NOT EXISTS $DB_USER@'%' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON *.* TO $DB_USER@'%' IDENTIFIED BY '$DB_PASS' WITH GRANT OPTION;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';
CREATE DATABASE IF NOT EXISTS $DB_NAME;
FLUSH PRIVILEGES;
" > setup.sql
# ALTER USER is change root password

mysqld --bootstrap < setup.sql
# bootstrap mode is prevent database become constant server to keep listening client request, only init and run only script given

sed -i 's/# port = 3306/port = 3306/' /etc/mysql/my.cnf
# uncomment the port = 3306 in the config (expose the 3306 port)

sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
# set the 127.0.0.1 to 0.0.0.0 to let any ip to connect db

mysqld_safe
# run the mariadb in safe mode to prevent crash cannot restart, got log
