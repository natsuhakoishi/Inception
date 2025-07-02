#!/bin/bash

if [ ! -a "wp-cli.phar" ];
then
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
fi

if [ ! -d "/var/www/html/wordpress" ];
then
	mkdir /var/www/html/wordpress
	echo "Wordpress Directory Created"
fi

if [ -z "$(ls -A /var/www/html/wordpress)" ];
then
	wp core download --path=/var/www/html/wordpress --allow-root
	echo "Wordpress Core Downloaded"

	wp core config --path=/var/www/html/wordpress \
		--dbhost=mariadb \
		--dbname=$DB_NAME \
		--dbuser=$DB_USER \
		--dbpass=$DB_UPASS \
		--allow-root
	echo "wp-config.php Created"

	wp core install --path=/var/www/html/wordpress \
		--url=$DOMAIN_NAME \
		--title="I hate Inception" \
		--admin_name=$WP_ADMIN \
		--admin_password=$WP_APASS \
		--admin_email=$WP_EA \
		--allow-root
	echo "Wordpress Installed"

	wp user create --path=/var/www/html/wordpress \
		$WP_USER $WP_UEA --user_pass=$WP_UPASS \
		--role=author --allow-root
	echo "Wordpress User Created"

	wp theme install twentytwentytwo --activate --allow-root
	echo "Wordpress Theme Installed and Activated"
fi

sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

mkdir -p /run/php

echo "Starting: php-fpm7.4"
php-fpm7.4 -F -R
