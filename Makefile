-include .env

VERSION := $(shell git describe --tags --abbrev=0)
BUILD := $(shell git rev-parse --short HEAD)
BUILD_DIR=$(shell "$(PWD)")
PROJECT_NAME=$(shell basename "$(PWD)")


# .PHONY: build test push shell run start stop logs clean release
.PHONY: up

default: up

up: # Builds, (re)creates, starts, and attaches to containers for a service.
	# docker-compose up --detach --force-recreate --remove-orphans --renew-anon-volumes
	@docker-compose up --detach

build:
	@docker-compose down &> /dev/null
	@make docker-build-nginx
	@make docker-build-php
	@make docker-build-php-cli
	@make up

docker-build-php:
	@docker build \
	--file ./docker/php/Dockerfile \
	--tag "soprun/sandbox-php:latest" \
	.

docker-build-php-cli:
	@docker build \
	--file ./docker/php-cli/Dockerfile \
	--tag "soprun/sandbox-php-cli:latest" \
	.

docker-build-nginx:
	@docker build \
	--file ./docker/nginx/Dockerfile \
	--tag "soprun/sandbox-nginx:latest" \
	.

docker-exec: # Shell access
	@docker exec -ti php sh

docker-clean:
	@docker-compose down &> /dev/null
	@docker system prune --volumes --force

docker-config:
	@docker-compose config

composer:
	@docker-compose exec -T $(PHP_SERVICE) composer install

vault-exec: # Shell access
	@docker exec -ti vault sh

php-env-vars:
	@docker exec -ti php bin/console debug:container --env-vars --show-hidden
