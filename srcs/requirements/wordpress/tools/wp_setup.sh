#!/bin/bash

if [ ! -a "wp-cli.phar" ];
then
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
fi

if [ ! -d "/var/www/html/wordpress" ];
then
	mkdir -p /var/www/html/wordpress
fi

if [ -z "$(ls -A /var/www/html/wordpress)" ];
then
	wp core download --path=/var/www/html/wordpress --allow-root
	echo "Wordpress Core Downloaded"

	wp core config --path=/var/www/html/wordpress \
	--dbhost=mariadb --dbname=$DB_NAME \
	--dbuser=$DB_USER --dbpass=$DB_PASS \
	--allow-root
	echo "wp-config created"

	chmod 644 /requirements/wordpress/wpf/wp-config.php

	wp core install --path=/var/www/html/wordpress \
	--url=https://yyean-wa.42.fr --title="I hate Inception" \
	--admin_name=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS \
	--admin_email=$WP_ADMIN_EMAIL --allow-root
	echo "Wordpress Core Installed"

	wp user create --path=/var/www/html/wordpress \
	$WP_USER $WP_EMAIL --user_pass=$WP_PASS \
	--role=author --allow-root

	wp install theme twentytwentytwo --activate --allow-root
fi

sed -i 's;listen = /run/php/php7.4-fpm.sock;listen = 9000;' /etc/php/7.4/fpm/pool.d/www.conf

mkdir -p /run/php

echo "Starting: php-fpm7.4"
php-fpm7.4 -F -R
