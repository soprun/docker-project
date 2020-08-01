#!/bin/sh

set -ex

docker build \
	--file ./docker/nginx/Dockerfile \
	--tag sandbox/nginx \
	.

docker build \
	--build-arg app_env=dev \
	--build-arg app_debug=true \
	--file ./docker/php-cli/Dockerfile \
	--tag sandbox/php-cli \
	.

docker build \
	--build-arg app_env=dev \
	--build-arg app_debug=true \
	--file ./docker/php-fpm/Dockerfile \
	--tag sandbox/php-fpm \
	.

docker-compose up --build --detach --force-recreate --remove-orphans

docker run -it --rm --volume $(pwd):/app sandbox/php-fpm composer install