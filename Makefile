-include .env

PHP_SERVICE := dsa_php

build:
	@docker-compose up -d

composer-install:
	@docker-compose exec -T $(PHP_SERVICE) composer install

database-schema-update:
	@docker-compose exec -T $(PHP_SERVICE) bin/console doctrine:schema:update

test-security-check:
	@docker-compose exec -T $(PHP_SERVICE) bin/console security:check

down:
	@docker-compose down --volumes
	@make -s clean

clean:
	@docker system prune --volumes --force

all:
	@make -s build
	@make -s composer
	@make -s database
	@make -s test
	@make -s down
	@make -s clean