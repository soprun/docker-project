-include .env
-include ./docker/.env.local

DOCKER_COMPOSE_DIR=./
DOCKER_COMPOSE_FILE=$(DOCKER_COMPOSE_DIR)/docker-compose.yml
DOCKER_COMPOSE=docker-compose -f $(DOCKER_COMPOSE_FILE) --project-directory $(DOCKER_COMPOSE_DIR)

DEFAULT_CONTAINER=workspace

# Self-Documented Makefile see https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.DEFAULT_GOAL := help
.PHONY: help

#help:
#	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-27s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ [Docker] Build / Infrastructure

.PHONY: docker-build
docker-build: ## Build all docker images. Build a specific image by providing the service name via: make docker-build CONTAINER=<service>
	@$(DOCKER_COMPOSE) build --parallel $(CONTAINER) && \
	@$(DOCKER_COMPOSE) up --detach --force-recreate $(CONTAINER)

.PHONY: docker-down
docker-down: ## Stop all docker containers. To only stop one container, use CONTAINER=<service>
	@$(DOCKER_COMPOSE) down $(CONTAINER)

.PHONY: docker-exec
docker-exec: ## Execute a command in a running container
	@$(DOCKER_COMPOSE) exec -T $(DEFAULT_CONTAINER) sh

##@ [Application]

#RUN_IN_DOCKER := $(DOCKER_COMPOSE) exec -T --user $(RUN_IN_DOCKER_USER) $(RUN_IN_DOCKER_CONTAINER)

.PHONY: composer
composer: ## Run composer and provide the command via ARGS="command --options"
	$(RUN_IN_DOCKER) composer $(ARGS)

.PHONY: artisan
artisan: ## Run artisan and provide the command via ARGS="command --options"
	$(RUN_IN_DOCKER) php artisan $(ARGS)

.PHONY: composer-install
composer-install: ## Run composer install
	$(RUN_IN_DOCKER) composer install

# https://github.com/paslandau/docker-php-tutorial/blob/part_4_setup-laravel-on-docker/Makefile
# https://www.pascallandau.com/blog/structuring-the-docker-setup-for-php-projects/#makefile-and-bashrc
# https://www.digitalocean.com/community/tutorials/how-to-containerize-a-laravel-application-for-development-with-docker-compose-on-ubuntu-18-04-ru


# --------

# https://github.com/sickill/chruby/blob/master/Makefile

#NAME=docker-project
#VERSION=0.3.9
#AUTHOR=soprun
#URL=https://github.com/$(AUTHOR)/$(NAME)
#
#PKG_DIR=pkg
#PKG_NAME=$(NAME)-$(VERSION)
#PKG=$(PKG_DIR)/$(PKG_NAME).tar.gz
#SIG=$(PKG).asc
#
#pkg:
#	mkdir $(PKG_DIR)
#
#download: pkg
#	wget -O $(PKG) $(URL)/archive/v$(VERSION).tar.gz
#
#build: pkg
#	git archive --output=$(PKG) --prefix=$(PKG_NAME)/ HEAD
#
#sign: $(PKG)
#	gpg --sign --detach-sign --armor $(PKG)
#	git add $(PKG).asc
#	git commit $(PKG).asc -m "Added PGP signature for v$(VERSION)"
#	git push origin master
#
#verify: $(PKG) $(SIG)
#	gpg --verify $(SIG) $(PKG)
#
#clean:
#	rm -f $(PKG) $(SIG)
#
#all: $(PKG) $(SIG)



# The build stage
# The release stage
# The run stage
.PHONY: lint-container
lint-container: ## dasd a
	docker exec -it php bash /app/bin/console lint:container