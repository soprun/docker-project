THIS_FILE := $(lastword $(MAKEFILE_LIST))

APP_ENV := dev
TAG := latest

ACCOUNT := soprun

SERVICE_PHP := sandbox-php
SERVICE_PHP_CLI := sandbox-php-cli
SERVICE_NGINX := sandbox-nginx

IMAGE_PHP := $(ACCOUNT)/$(SERVICE_PHP)
IMAGE_PHP_CLI := $(ACCOUNT)/$(SERVICE_PHP_CLI)
IMAGE_NGINX := $(ACCOUNT)/$(SERVICE_NGINX)

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
	docker-compose $(COMPOSE_FILE) up --build --detach

build: ## Build services.
	$(info Make: Building "$(APP_ENV)" environment images.)
	docker-compose $(COMPOSE_FILE) build --no-cache

rebuild: ## Rebuild services.
	$(info Make: Rebuilding "$(APP_ENV)" environment images.)
	docker-compose $(COMPOSE_FILE) up --build --detach --force-recreate --remove-orphans --renew-anon-volumes

stop: ## Stopping containers.
	$(info Make: Stopping "$(APP_ENV)" environment containers.)
	@docker-compose stop

down: ## tops containers and removes containers, networks, volumes, and images
	docker-compose $(COMPOSE_FILE) down --volumes --remove-orphans --rmi local
	@make -s clean

clean: ## Docker system clear
	@docker system prune --volumes --force

lint-dotenv: ## It checks .env files for problems that may cause the application to malfunction
	@-dotenv-linter --show-checks ./docker
	@-dotenv-linter --show-checks ./app

