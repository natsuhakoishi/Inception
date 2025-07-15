#!/bin/bash

# if dont have wp-cli.phar, use wget to download it (Wordpress CLI is command line interface, means that we can use script to control wordpress)
if [ ! -a "wp-cli.phar" ];
then
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
fi

# if the /wordpress path not exist, create it, -p make sure the parent dir create together if not exist
if [ ! -d "/var/www/html/wordpress" ];
then
	mkdir -p /var/www/html/wordpress
fi

# -z make sure /wordpress inside is empty then download the wordpress to prevent corruption of exist data
if [ -z "$(ls -A /var/www/html/wordpress)" ];
then
	wp core download --path=/var/www/html/wordpress --allow-root
	echo "Wordpress Core Downloaded"

	wp core config --path=/var/www/html/wordpress \
	--dbhost=mariadb --dbname=$DB_NAME \
	--dbuser=$DB_USER --dbpass=$DB_PASS \
	--allow-root
	echo "wp-config.php created"

	chmod 644 /requirements/wordpress/wpf/wp-config.php
	# grant the wp-config permission 644 (rw- for user, r-- for groups, r-- for others), this is just addition

	wp core install --path=/var/www/html/wordpress \
	--url=$DOMAIN_NAME --title="I hate Inception" \
	--admin_name=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS \
	--admin_email=$WP_ADMIN_EMAIL --allow-root
	echo "Wordpress Core Installed"

	wp user create --path=/var/www/html/wordpress \
	$WP_USER $WP_EMAIL --user_pass=$WP_PASS \
	--role=author --allow-root

	wp theme install twentytwentytwo --activate --allow-root
fi

# set the listen socket from default to port 9000, this can make nginx can communicate with wordpress
sed -i 's;listen = /run/php/php7.4-fpm.sock;listen = 9000;' /etc/php/7.4/fpm/pool.d/www.conf

# make a temp dir for PHP-FPM running
mkdir -p /run/php

echo "Starting: php-fpm7.4"
php-fpm7.4 -F -R
# -F -> run in frontground, -R -> root allow
