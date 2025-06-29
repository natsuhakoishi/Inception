all: up

up:
	docker compose -f ./srcs/docker-compose.yml up -d

down:
	docker compose -f ./srcs/docker-compose.yml down

stop:
	docker compose -f ./srcs/docker-compose.yml stop

start:
	docker compose -f ./srcs/docker-compose.yml start

status:
	docker ps

clean:
	docker compose -f ./srcs/docker-compose.yml down -v --remove-orphans
	docker image prune -af
	docker volume prune -f
	docker network prune -f

# scp -r ~/42cp/wip/Inception natsuhakoishi@192.168.1.127:~/	           //send file to VM
# ssh natsuhakoishi@192.168.1.127                                          //connect to VM
# docker context update inception-vm --docker "ssh://natsuhakoishi@new_ip" //change ssh link ip if vm ip diff
