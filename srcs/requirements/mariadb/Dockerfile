FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

COPY . .

CMD ["/bin/bash", "/tools/mariadb_setup.sh"]
