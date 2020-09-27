-include ./docker/.env
-include ./app/.env
-include ./app/.env.local

export $(shell sed 's/=.*//' ./docker/.env)
export $(shell sed 's/=.*//' ./app/.env)

SHELL := /bin/bash
#TAG := latest
#ACCOUNT := soprun

#ifndef TAG
#$(error The TAG variable is missing.)
#endif

ifndef APP_ENV
$(error The APP_ENV variable is missing.)
endif

ifeq ($(filter $(APP_ENV),test dev stag prod),)
$(error The APP_ENV variable is invalid.)
endif

SERVICE_NGINX := nginx
SERVICE_PHP := php
SERVICE_PHP_WORKSPACE := php_workspace

#IMAGE_PHP := $(ACCOUNT)/$(SERVICE_PHP)
#IMAGE_PHP_CLI := $(ACCOUNT)/$(SERVICE_PHP_CLI)
#IMAGE_NGINX := $(ACCOUNT)/$(SERVICE_NGINX)

#ifeq (,$(filter $(APP_ENV),test dev))
#COMPOSE_FILE := --file ./docker/docker-compose.yml
#endif

# $(info Make: Starting "$(APP_ENV)" environment containers.)

DOCKER_COMPOSE := docker-compose --file ./docker/docker-compose.yml

.DEFAULT_GOAL := help
# .PHONY: help up build build-php rebuild stop down clean check-dotenv check-security \
# 	symfony-cli console-about console-env-vars exec

help: ## Display this help message
	@printf "\nPlease use \033[33m\'make <target>'\033[0m where \033[33m<target>\033[0m is one of\n\n"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[34m  %-25s\033[0m %s\n", $$1, $$2}'

up: ## Run application in the docker-compose
	$(DOCKER_COMPOSE) up --detach

down: ## Stops containers and removes containers, networks, volumes, and images
	$(DOCKER_COMPOSE) down --volumes --remove-orphans --rmi local

rebuild: ## Rebuild services.
	@make -s down
	$(DOCKER_COMPOSE) up --build --detach --force-recreate --remove-orphans --renew-anon-volumes

logs: ## View logs from docker containers
	$(DOCKER_COMPOSE) logs --follow


#build: ## Build services.
#	$(info Make: Building "$(APP_ENV)" environment images.)
#	$(DOCKER_COMPOSE) build --parallel

#build-php: ## Build services.
#	$(DOCKER_COMPOSE) build --compress --parallel --force-rm $(SERVICE_PHP)

#stop: ## Stopping containers.
#	$(info Make: Stopping "$(APP_ENV)" environment containers.)
#	$(DOCKER_COMPOSE) stop

#down: ## tops containers and removes containers, networks, volumes, and images
#	$(DOCKER_COMPOSE) down --volumes --remove-orphans --rmi local
#	@make -s clean

clean: ## Docker system clear
	@docker system prune --volumes --force

check-dotenv: ## It checks .env files for problems that may cause the application to malfunction
	@-dotenv-linter ./docker
	@-dotenv-linter ./app

console-about: ## Displays information about project
	$(info Make: Stopping "$(APP_ENV)" environment containers.)
	$(DOCKER_COMPOSE) exec $(SERVICE_PHP) php bin/console about

console-env-vars: ## Symfony Container Environment Variables
	$(DOCKER_COMPOSE) exec $(SERVICE_PHP) php bin/console debug:container --env-vars --show-hidden

exec: ## Run a command in a running container
	@docker exec --interactive --tty $(SERVICE_PHP) bash
