#!/bin/bash

echo "
FLUSH PRIVILEGES;
CREATE USER IF NOT EXISTS '$DB_ADMIN'@'localhost' IDENTIFIED BY '$DB_APASS';
GRANT ALL PRIVILEGES ON *.* TO '$DB_ADMIN'@'localhost' IDENTIFIED BY '$DB_APASS' WITH GRANT OPTION;
CREATE USER IF NOT EXISTS '$DB_ADMIN'@'%' IDENTIFIED BY '$DB_APASS';
GRANT ALL PRIVILEGES ON *.* TO '$DB_ADMIN'@'%' IDENTIFIED BY '$DB_APASS' WITH GRANT OPTION;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_UPASS';
GRANT ALL PRIVILAGES ON *.* TO '$DB_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';
CREATE DATABASE IF NOT EXISTS $DB_NAME;
FLUSH PRIVILEGES;
" > setup.sql

mysqld --user=mysql --bootstrap < setup.sql

sed -i 's/# port = 3306/port = 3306/' /etc/mysql/my.cnf
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

exec mysqld_safe
