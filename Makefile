-include ./docker/.env

# Bash is required as the shell
SHELL := /bin/bash

GIT_TAG := $(shell git describe --tags --abbrev=0)
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
GIT_COMMIT_ID := $(shell git rev-parse --short HEAD)

#PROJECT_DIR="$(PWD)"
#DOCKER_DIR="${PROJECT_DIR}/docker"
#SOURCE_DIR="${PROJECT_DIR}/src"
# PROJECT_NAME=$(shell basename "$(PWD)")
# RELEASE_TAG := v$(shell date +%Y%m%d-%H%M%S-%3N)

SERVICE_PHP := php
SERVICE_NGINX := nginx

all: up

print:
	@echo "GIT_TAG: ${GIT_TAG}"
	@echo "GIT_BRANCH: ${GIT_BRANCH}"
	@echo "GIT_COMMIT_ID: ${GIT_COMMIT_ID}"

	@echo "PROJECT_NAME: ${PROJECT_NAME}"
	@#echo "PROJECT_DIR: ${PROJECT_DIR}"
	@#echo "DOCKER_DIR: ${DOCKER_DIR}"
	@#echo "SOURCE_DIR: ${SOURCE_DIR}"

up:
	@docker-compose \
		--project-name "${PROJECT_NAME}" \
		up \
		--detach \
		--force-recreate \
		--remove-orphans \
		--renew-anon-volumes

#up:
#	@docker-compose \
#		--project-name "${PROJECT_NAME}" \
#		--project-directory "${PROJECT_DIR}" \
#		--file "${PROJECT_DIR}/docker/docker-compose.yml" \
#		up --detach
