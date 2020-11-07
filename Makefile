-include ./docker/.env

# DOCKER_COMPOSE_FILES := ./docker/docker-compose.yml
DOCKER_COMPOSE := docker-compose --file ./docker/docker-compose.yaml

# .DEFAULT_GOAL := help
# .PHONY: help up build build-php rebuild stop down clean check-dotenv check-security \
# 	symfony-cli console-about console-env-vars exec

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

build: ## Build or rebuild services
	$(DOCKER_COMPOSE) build --parallel

rebuild: down-force up-force ## dad
	@echo 'lol'
