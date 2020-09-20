-include .env

PHP_SERVICE := php

up:
	@docker-compose up \
		--detach \
		--force-recreate \
		--remove-orphans \
		--renew-anon-volumes

build:
	@docker build \
		--file "./docker/nginx/Dockerfile" \
		--tag "soprun/sandbox-nginx:latest" \
		"."

	@docker build \
		--file "./docker/php/Dockerfile" \
		--target "composer" \
		--tag "soprun/sandbox-php:composer" \
		"."

	@docker build \
		--cache-from "soprun/sandbox-php:composer" \
		--file "./docker/php/Dockerfile" \
		--target "build" \
		--tag "soprun/sandbox-php:latest" \
		--tag "soprun/sandbox-php:build" \
		"."

	@docker build \
		--cache-from "soprun/sandbox-php:composer" \
		--cache-from "soprun/sandbox-php:build" \
		--file "./docker/php/Dockerfile" \
		--target "dev" \
		--tag "soprun/sandbox-php:dev" \
		"."

	@docker build \
		--cache-from "soprun/sandbox-php:composer" \
		--cache-from "soprun/sandbox-php:build" \
		--file "./docker/php/Dockerfile" \
		--target "prod" \
		--tag "soprun/sandbox-php:prod" \
		"."

build-push:
	@docker push soprun/sandbox-nginx
	@docker push soprun/sandbox-php

#composer-install:
#	@docker-compose exec -T $(PHP_SERVICE) composer install
#
#database-schema-update:
#	@docker-compose exec -T $(PHP_SERVICE) bin/console doctrine:schema:update
#
#test-security-check:
#	@docker-compose exec -T $(PHP_SERVICE) bin/console security:check

down:
	@docker-compose down --volumes
	@make -s clean

clean:
	@docker system prune --volumes --force

all:
	@make -s build
	@make -s up
	@make -s build-push
#	@make -s composer
#	@make -s database
#	@make -s test
	@make -s down
	@make -s clean
