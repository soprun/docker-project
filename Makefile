THIS_FILE := $(lastword $(MAKEFILE_LIST))

APP_ENV := dev
TAG := latest

ACCOUNT := soprun

SERVICE_NGINX := nginx
SERVICE_PHP := php
SERVICE_PHP_WORKSPACE := php_workspace

# IMAGE_PHP := $(ACCOUNT)/$(SERVICE_PHP)
#IMAGE_PHP_CLI := $(ACCOUNT)/$(SERVICE_PHP_CLI)
#IMAGE_NGINX := $(ACCOUNT)/$(SERVICE_NGINX)

COMPOSE_FILE := --file ./docker/docker-compose.yml

ifndef TAG
$(error The TAG variable is missing.)
endif

ifndef APP_ENV
$(error The ENV variable is missing.)
endif

ifeq ($(filter $(APP_ENV),test dev stag prod),)
$(error The ENV variable is invalid.)
endif

#ifeq (,$(filter $(APP_ENV),test dev))
#COMPOSE_FILE := --file ./docker/docker-compose.yml
#endif

.DEFAULT_GOAL := help
.PHONY: help up build rebuild stop down lint-dotenv clean

default: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

up: ## Build and start services
	$(info Make: Starting "$(APP_ENV)" environment containers.)
	docker-compose $(COMPOSE_FILE) up --quiet-pull --build --detach

build: ## Build services.
	$(info Make: Building "$(APP_ENV)" environment images.)
	docker-compose $(COMPOSE_FILE) build --no-cache

rebuild: ## Rebuild services.
	$(info Make: Rebuilding "$(APP_ENV)" environment images.)
	docker-compose $(COMPOSE_FILE) up --quiet-pull --build --detach --force-recreate --remove-orphans --renew-anon-volumes

stop: ## Stopping containers.
	$(info Make: Stopping "$(APP_ENV)" environment containers.)
	@docker-compose stop

down: ## tops containers and removes containers, networks, volumes, and images
	docker-compose $(COMPOSE_FILE) down --volumes --remove-orphans --rmi local
	@make -s clean

clean: ## Docker system clear
	@docker system prune --volumes --force

check-dotenv: ## It checks .env files for problems that may cause the application to malfunction
	@-dotenv-linter ./docker
	@-dotenv-linter ./app

check-security: ## PHP Security Checker
	@docker pull symfonycorp/cli:latest
	@docker run --rm --volume "$(PWD)/app:/app" --workdir "/app" symfonycorp/cli check:security

symfony-cli: ## Symfony CLI
	@docker pull symfonycorp/cli:latest
	@docker run --rm --volume "$(PWD)/app:/app" --workdir "/app" symfonycorp/cli $(ARGS)

console-about: ## Displays information about project
	@docker-compose $(COMPOSE_FILE) exec $(SERVICE_PHP) php bin/console about

console-env-vars: ## Symfony Container Environment Variables
	@docker-compose $(COMPOSE_FILE) exec $(SERVICE_PHP) php bin/console debug:container --env-vars --show-hidden

exec: ## Run a command in a running container
	@docker exec --interactive --tty $(SERVICE_PHP) sh
