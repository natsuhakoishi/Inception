FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

COPY ./tools/mariadb_setup.sh /mariadb_setup.sh

RUN chmod +x /mariadb_setup.sh

EXPOSE 3306

ENTRYPOINT ["/mariadb_setup.sh"]
