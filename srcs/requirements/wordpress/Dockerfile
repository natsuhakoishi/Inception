FROM debian:bullseye

RUN apt-get update && apt-get install -y php-fpm php-mysql php-common wget

COPY ./tools/wp_setup.sh /wp_setup.sh

RUN chmod +x /wp_setup.sh

EXPOSE 9000

ENTRYPOINT ["/wp_setup.sh"]
