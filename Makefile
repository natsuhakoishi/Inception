DC := ./srcs/docker-compose.yml

MOUNTPOINT = /home/yyean-wa/data
WP_DB_DIR = /wordpress_database
WP_FL_DIR = /wordpress_files

all: re

build:
	if [ ! -d $(MOUNTPOINT)$(WP_DB_DIR) ]; then\
		sudo mkdir -p $(MOUNTPOINT)$(WP_DB_DIR);\
	fi
	if [ ! -d $(MOUNTPOINT)$(WP_FL_DIR) ]; then\
		sudo mkdir -p $(MOUNTPOINT)$(WP_FL_DIR);\
	fi

	docker compose -f $(DC) build

up:
	docker compose -f $(DC) up -d

down:
	docker compose -f $(DC) down

ps:
	docker ps

clean:
	docker system prune

vclean:
	sudo rm -rf /home/yyean-wa/data/wordpress_database/*
	sudo rm -rf /home/yyean-wa/data/wordpress_files/*

fclean:
	docker stop $(shell docker ps -qa) 2>/dev/null || true
	docker rm $(shell docker ps -qa) 2>/dev/null || true
	docker rmi $(shell docker images -qa) 2>/dev/null || true
	docker volume rm $(shell docker volume ls -q) 2>/dev/null || true
	docker network rm $(shell docker network ls -q) 2>/dev/null || true

re: down fclean up

# VM
# scp -r ~/42cp/wip/Inception natsuhakoishi@192.168.1.127:~/	           //send file to VM
# ssh natsuhakoishi@192.168.1.127                                          //connect to VM
# docker context update inception-vm --docker "host=ssh://natsuhakoishi@192.168.1.127" //change ssh link ip if vm ip diff

# docker
# docker ps (ls container)
# docker exec -it <container> bash

# mariadb
# mysql -u root -p
# SELECT / USE
