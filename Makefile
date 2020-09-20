-include .env

# Bash is required as the shell
#SHELL := /bin/bash

#VERSION := $(shell git describe --tags --abbrev=0)
#BUILD := $(shell git rev-parse --short HEAD)
#BUILD_DIR=$(shell "$(PWD)")
#PROJECT_NAME=$(shell basename "$(PWD)")
#RELEASE_TAG := v$(shell date +%Y%m%d-%H%M%S-%3N)


# .PHONY: build test push shell run start stop logs clean release
.PHONY: up

default: up

up: # Builds, (re)creates, starts, and attaches to containers for a service.
	@docker-compose up --build --detach --force-recreate
	#@docker-compose up --detach --force-recreate --remove-orphans --renew-anon-volumes
	#@docker-compose up --detach

build:
	@docker-compose build --file docker-compose.yml

build-php:
	@docker build --file "./docker/php/Dockerfile" --tag "docker-php:composer" --target composer "."
	@docker build --cache-from "docker-php:composer" --file "./docker/php/Dockerfile" --tag "docker-php:builder" --target builder "."
	@docker build --cache-from "docker-php:builder" --file=./docker/php/Dockerfile --tag "docker-php:development" --target development "."
