#!/bin/bash

# use openssl to create a self-signed cert
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$CN/emailAddress=$EMAIL_ADDRESS";
# -x509 -> get cert directly without req to CA
# -nodes -> get rivate key without encryption
# -days 365 -> cert valid for 365 days
# -newkey rsa:2048 -> create a 2048-bit length RSA key, 1024 too short, 4096 too time-consume
# -keyout -> the path save key, -out -> the path save cert
# -subj -> the data of cert, no need set manually

nginx -g 'daemon off;';
# let nginx run in foreground, not backgrond (so off the daemon) to let docker or service can view log and status
