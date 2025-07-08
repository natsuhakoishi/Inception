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

mysqld --bootstrap < setup.sql

sed -i 's/# port = 3306/port = 3306/' /etc/mysql/my.cnf
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

mysqld_safe
