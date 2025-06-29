FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

COPY ./tools/db_setup.sh /db_setup.sh

RUN chmod +x /db_setup.sh

EXPOSE 3306

ENTRYPOINT ["/db_setup.sh"]
