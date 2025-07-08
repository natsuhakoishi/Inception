FROM debian:bullseye

COPY . .

RUN apt-get update && apt-get install -y php-fpm php-mysql php-common wget

CMD ["/bin/bash", "/tools/wp_setup.sh"]
