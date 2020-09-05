-include .env

VERSION := $(shell git describe --tags --abbrev=0)
BUILD := $(shell git rev-parse --short HEAD)
BUILD_DIR=$(shell "$(PWD)")
PROJECT_NAME=$(shell basename "$(PWD)")


# .PHONY: build test push shell run start stop logs clean release
.PHONY: init

default: build

init:
	@docker-compose down &> /dev/null
	@make build-nginx
	@make build-php
	@make up

build-php:
	@docker build \
	--file ./docker/php/Dockerfile \
	--tag "soprun/sandbox-php:latest" \
	.

build-nginx:
	@docker build \
	  --file ./docker/nginx/Dockerfile \
	  --tag "soprun/sandbox-nginx:latest" \
	  .

up: # Builds, (re)creates, starts, and attaches to containers for a service.
	@docker-compose up --detach --force-recreate --remove-orphans --renew-anon-volumes

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
