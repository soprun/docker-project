-include ./docker/.env
-include ./app/.env
-include ./app/.env.local

export $(shell sed 's/=.*//' ./docker/.env)
export $(shell sed 's/=.*//' ./app/.env)

SHELL := /bin/bash
ACCOUNT := soprun
TAG_LATEST := latest
TAG_PROD := prod
TAG_DEV := dev

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

IMAGE_PHP := $(ACCOUNT)/$(SERVICE_PHP)
IMAGE_PHP_DEV := $(ACCOUNT)/$(SERVICE_PHP):$(TAG_DEV)
IMAGE_PHP_PROD := $(ACCOUNT)/$(SERVICE_PHP):$(TAG_PROD)

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

build: ## Build services.
	$(info Make: Building "$(APP_ENV)" environment images.)
	$(DOCKER_COMPOSE) up --build --detach

rebuild: ## Rebuild services.
	@make -s down
	$(DOCKER_COMPOSE) up --build --detach --force-recreate --remove-orphans --renew-anon-volumes

logs: ## View logs from docker containers
	$(DOCKER_COMPOSE) logs --follow

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

composer-install: ## Installs the project dependencies
	docker run --rm --interactive --tty \
    --volume $(PWD)/app:/app \
    --volume $(COMPOSER_HOME):/tmp \
    composer install \
    --ignore-platform-reqs \
    --no-scripts

asea:
	mkdir -p /app/var
	chown -R www-data:www-data /app/var
	chmod -R 777 /app/var


PHP_SERVICE := php
PHP_TAG := sandbox-php-cli

#docker-build:
#	docker build --tag sandbox-php-cli . && docker run --name sandbox-php-cli sandbox-php-cli

docker-builder-php-dev:
	@docker builder build \
    --file "./docker/php/Dockerfile" \
    --target $(TAG_DEV) \
    --tag $(IMAGE_PHP_DEV) \
    .

	echo docker run \
    --name $(IMAGE_PHP_DEV) \
    --detach \
    --rm \
    $(IMAGE_PHP_DEV)




######

log-analyzer: ## real-time report:
	@cat access.log | docker run --rm -i -e LANG=$LANG allinurl/goaccess -a -o html --log-format COMBINED - > report.html

log-analyzer-real-time: ## real-time report:
	@cat access.log | docker run -p 7890:7890 --rm -i -e LANG=$LANG allinurl/goaccess -a -o html --log-format COMBINED --real-time-html - > report.html


# goaccess /var/log/nginx/access.log --log-format=COMBINED
# или чтобы посмотреть статистику за все время
# zcat /var/log/nginx/access.log.*.gz | goaccess /var/log/nginx/access.log --log-format=COMBINED

create-dhparam: ## Generation of Diffie-Hellman ciphersuites
	@$(info Generation of Diffie-Hellman ciphersuites)
	@openssl dhparam -noout -out "./docker/nginx/ssl/dhparam.pem" $(call args, 512)


# Update channel. Can be release, beta or edge. Uses edge by default.
CHANNEL ?= edge

# Version properties
COMMIT=$(shell git rev-parse --short HEAD)
TAG_NAME=$(shell git describe --abbrev=0)
RELEASE_VERSION=$(TAG_NAME)
SNAPSHOT_VERSION=$(RELEASE_VERSION)-SNAPSHOT-$(COMMIT)

# Set proper version
VERSION=
ifeq ($(TAG_NAME),$(shell git describe --abbrev=4))
	ifeq ($(CHANNEL),edge)
		VERSION=$(SNAPSHOT_VERSION)
	else
		VERSION=$(RELEASE_VERSION)
	endif
else
	VERSION=$(SNAPSHOT_VERSION)
endif

version:
	@echo $(COMMIT);
	@echo $(TAG_NAME);
	@echo $(RELEASE_VERSION);
	@echo $(SNAPSHOT_VERSION);
	@echo $(VERSION);
