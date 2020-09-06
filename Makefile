-include .env

# Bash is required as the shell
SHELL := /bin/bash

VERSION := $(shell git describe --tags --abbrev=0)
BUILD := $(shell git rev-parse --short HEAD)
BUILD_DIR=$(shell "$(PWD)")
PROJECT_NAME=$(shell basename "$(PWD)")
RELEASE_TAG := v$(shell date +%Y%m%d-%H%M%S-%3N)


# .PHONY: build test push shell run start stop logs clean release
.PHONY: up

default: up

up: # Builds, (re)creates, starts, and attaches to containers for a service.
	# docker-compose up --detach --force-recreate --remove-orphans --renew-anon-volumes
	@docker-compose up --detach

build:
	@docker-compose down &> /dev/null
	@make up

docker-exec: # Shell access
	@docker exec -ti php sh

docker-clean:
	@docker-compose down &> /dev/null
	@docker system prune --volumes --force

docker-config:
	@docker-compose config

docker-release:
	@git tag $(RELEASE_TAG)
	@git push origin $(RELEASE_TAG)

composer:
	@docker-compose exec -T $(PHP_SERVICE) composer install

vault-exec: # Shell access
	@docker exec -ti vault sh

php-env-vars:
	@docker exec -ti php-cli bin/console debug:container --env-vars --show-hidden

php-cli-check-platform-reqs:
	@docker exec -ti php-cli composer check-platform-reqs


lol:
	@docker build \
		--file ./docker/php/Dockerfile \
		--tag "soprun/sandbox-php:latest" \
		.