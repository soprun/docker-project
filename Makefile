-include .env
-include .env.local

# Self-Documented Makefile see https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.DEFAULT_GOAL := help
.PHONY: help

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-27s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

#######################################################################
##@ [Docker] Build / Infrastructure
#######################################################################

DOCKER_COMPOSE_FILE := "$(PROJECT_PATH_HOST)/docker-compose.yml"
DOCKER_COMPOSE := docker-compose \
	--file $(DOCKER_COMPOSE_FILE) \
	--project-directory $(PROJECT_PATH_HOST)

# --env-file "$(PROJECT_PATH_HOST)/.env"

DEFAULT_CONTAINER := php
RUN_IN_DOCKER := $(DOCKER_COMPOSE) exec -T $(DEFAULT_CONTAINER)

.PHONY: docker-config
docker-config: ## Validate and view the Compose file.
	$(DOCKER_COMPOSE) config

.PHONY: docker-pull
docker-pull: ## Pull service images and run service
	$(DOCKER_COMPOSE) pull && \
	$(DOCKER_COMPOSE) up --detach --force-recreate $(CONTAINER)

.PHONY: docker-build
docker-build: ## Build all docker images. Build a specific image by providing the service name via: make docker-build CONTAINER=<service>
	$(DOCKER_COMPOSE) build --parallel $(CONTAINER) && \
	$(DOCKER_COMPOSE) up --detach --force-recreate $(CONTAINER)

.PHONY: docker-down
docker-down: ## Stop all docker containers. To only stop one container, use CONTAINER=<service>
	$(DOCKER_COMPOSE) down $(CONTAINER)

#######################################################################
##@ [Application]
#######################################################################

.PHONY: exec
exec: ## Execute a command in a running container
	$(RUN_IN_DOCKER) bash

.PHONY: composer
composer: ## Run composer and provide the command via ARGS="command --options"
	$(RUN_IN_DOCKER) composer $(ARGS)

.PHONY: console
console: ## Run artisan and provide the command via ARGS="command --options"
	$(RUN_IN_DOCKER) console $(ARGS)

.PHONY: lint-container
lint-container:
	$(RUN_IN_DOCKER) console lint:container

.PHONY: lint-twig
lint-twig:
	$(RUN_IN_DOCKER) console lint:twig

codeclimate: ## Code Climate analysis platform.
	docker run \
	--interactive --tty --rm \
	--env CODECLIMATE_CODE="$PWD" \
	--volume "$PWD":/code \
	--volume /var/run/docker.sock:/var/run/docker.sock \
	--volume /tmp/cc:/tmp/cc \
	codeclimate/codeclimate $(BUNDLE_ARGS:-help)
