.PHONY: all docker-up docker-build docker-build-force docker-down

all: docker-up

# List containers
container_all := docker container list --all --quiet

docker-down:
	@printf '\n\e[1;32m%-6s\e[m\n' "Down docker... 🚛"
	@echo "########################################"
	@sleep .5

	@echo "=> Stop all containers ✅"
	@ - docker stop $(shell $(container_all)) &> /dev/null
	@sleep .5s

	@echo "=> Remove all containers ✅"
	@ - docker rm $(shell $(container_all)) &> /dev/null
	@sleep .5

	@echo "=> Remove all unused networks ✅"
	@ - docker network prune --force &> /dev/null
	@sleep .5

docker-remove: docker-down
	@printf '\n\e[1;31m%-6s\e[m\n' "Remove docker... 🚒"
	@echo "########################################"
	@sleep .5

	@echo "=> Remove all containers and volumes 🚒"
	@ - docker rm $(shell $(container_all)) --link --volumes &> /dev/null
	@sleep .5s

	@echo "=> Remove all networks 🚒"
	@ - docker network rm $(shell $(container_all)) &> /dev/null
	@sleep .5

	@echo "=> Remove all images 🚒"
	@ - docker rmi $(shell docker images --all --quiet) &> /dev/null
	@sleep .5

logs-fetch: # Fetch the logs of a container
	@docker logs app --follow --details
	# @tail -f var/logs/dev.log

app-cache-clear: # This is equivalent to running `composer run-script deploy`
	@php bin/console cache:clear --no-debug --env=prod
	@php bin/console cache:warmup --no-debug --env=prod

.PHONY: docker-list
container_list_format := 'table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'

docker-list:
	@docker container list --format $(container_list_format)

docker-port:
	@docker container list --filter publish=80-443 --format $(container_list_format)

# time php bin/console about

#symfony-cli: $(objs)
#	@docker run --rm symfonycorp/cli
#	@docker run --rm -v $(pwd):$(pwd) -w $(pwd) symfonycorp/cli -o $@ $(objs)

# docker network prune --force

# docker volume rm --force billing_php
# docker volume create --driver local --opt type=tmpfs --opt device=tmpfs php

# https://github.com/wodby/drupal-php/blob/master/7/Makefile

docker-build:
	@echo '=> building containers: 🐳 '
	@bash build.sh

docker-up:
	@printf '\e[1;32m%-6s\e[m\n' "Starting detached containers: 🐳 "
	@docker-compose --log-level info up \
       --detach \
       --force-recreate \
       --remove-orphans

docker-push:
	@echo '=> Docker push images: 🐳 '
	@docker push soprun/sandbox-nginx
	@docker push soprun/sandbox-php
	@docker push soprun/sandbox-php-cli


# lol

# xd