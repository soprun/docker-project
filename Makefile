-include ./.env
-include ./app/.env
-include ./app/.env.local
-include ./app/.env.prod
-include ./app/.env.prod.local

ifndef PROJECT_NAME
$(error The PROJECT_NAME variable is missing.)
endif

ifndef APP_ENV
$(error The APP_ENV variable is missing.)
endif

ifeq ($(filter $(APP_ENV),test dev stag prod),)
$(error The APP_ENV variable is invalid.)
endif

ifndef APP_DEBUG
$(error The APP_DEBUG variable is missing.)
endif

SHELL := /bin/bash

REGISTRY_HOST := docker.io
REGISTRY_ACCOUNT := $(USER)

TAG_LATEST := latest
TAG_STAGE := stage
TAG_PROD := prod
TAG_DEV := dev

SERVICE_PHP_FPM := sandbox-main-php
SERVICE_PHP_CLI := sandbox-main-php
SERVICE_PHP_WORKSPACE := sandbox-main-php
SERVICE_NGINX := sandbox-main-nginx

IMAGE_PHP_FPM := $(REGISTRY_ACCOUNT)/$(SERVICE_PHP_FPM)
IMAGE_PHP_CLI := $(REGISTRY_ACCOUNT)/$(SERVICE_PHP_CLI)
IMAGE_PHP_WORKSPACE := $(REGISTRY_ACCOUNT)/$(SERVICE_PHP_WORKSPACE)
IMAGE_NGINX := $(REGISTRY_ACCOUNT)/$(SERVICE_NGINX)

ifeq ($(TAG_NAME),$(shell git describe --abbrev=4))
	ifeq ($(CHANNEL),edge)
		VERSION=$(SNAPSHOT_VERSION)
	else
		VERSION=$(RELEASE_VERSION)
	endif
else
	VERSION=$(SNAPSHOT_VERSION)
endif

#PROJECT_NAME=$(shell basename $(CURDIR))

PWD := $(shell pwd)

DOCKER_COMPOSE := docker-compose --file "$(PWD)/docker-compose.yaml"
DOCKER_BUILD_CONTEXT=.
DOCKER_FILE_PATH=Dockerfile

#DOCKER_COMPOSE = docker-compose
#EXEC_PHP       = $(DOCKER_COMPOSE) exec -T php
#SYMFONY        = $(EXEC_PHP) bin/console
#COMPOSER       = $(EXEC_PHP) composer

# Version properties
COMMIT=$(shell git rev-parse --short HEAD)
TAG_NAME=$(shell git describe --abbrev=0)
RELEASE_VERSION=$(TAG_NAME)
SNAPSHOT_VERSION=$(RELEASE_VERSION)-SNAPSHOT-$(COMMIT)

VERSION :=

.DEFAULT_GOAL := help

help: ## Display this help message
	@printf "\nPlease use \033[33m\'make <target>'\033[0m where \033[33m<target>\033[0m is one of\n\n"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[34m  %-25s\033[0m %s\n", $$1, $$2}'

up: ## Run application in the docker-compose
	$(DOCKER_COMPOSE) up --detach

up-force: ## Run application in the docker-compose and recreate containers
	$(DOCKER_COMPOSE) up --detach \
	# Build or rebuild services \
	--build \
	# Recreate containers even if their configuration and image haven't changed. \
	--force-recreate \
	# Recreate anonymous volumes instead of retrieving data from the previous containers. \
	--renew-anon-volumes \
	# Remove containers for services not defined in the Compose file. \
	--remove-orphans

### Shutdown and cleanup
down: ## Removes containers, default network, but preserves your PostgreSQL database.
	$(DOCKER_COMPOSE) down

down-force: ## Removes containers, default network, and the PostgreSQL database.
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

config: ## Validate and view the Compose file
	$(DOCKER_COMPOSE) config

#build: ## Build or rebuild services
#$(DOCKER_COMPOSE) build

rebuild: down-force up-force ## dad
	@echo 'lol'

#remove-images: ## Remove all images.
#	$(shell docker images --all --quiet)
#	 @docker remove --force $(shell docker images --all --quiet)
# docker rmi --force $(docker images --all --quiet) &>/dev/null;

composer-install:
	@docker run --rm --interactive --tty --volume "$PWD:/app" \
	composer install --ignore-platform-reqs --no-scripts


docker-push:
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

#
#	@echo $(PROJECT_NAME)
#	@echo $(IMAGE)
#
#	@echo TAG_LATEST: $(TAG_LATEST)
#	@echo TAG_PROD: $(TAG_PROD)
#	@echo TAG_DEV: $(TAG_DEV)

version:
	@echo $(COMMIT);
	@echo $(TAG_NAME);
	@echo $(RELEASE_VERSION);
	@echo $(SNAPSHOT_VERSION);
	@echo $(VERSION);

list = c

all : $(list)
		for i in $(list); do \
				echo $$i; \
		done

about:
	$(info The project name: $(PROJECT_NAME))

	@echo $(files)
	@echo $(REGISTRY_HOST)
	@echo $(REGISTRY_ACCOUNT)

clean:;

target:;

## Install application
install:
	# Composer
	composer install --verbose


## Build application
build:
	@echo "213"

build@demo: export SYMFONY_ENV = prod
build@demo:

build@prod: export SYMFONY_ENV = prod
build@prod:
