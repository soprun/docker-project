#!/bin/sh

set -ex

docker build \
  --build-arg APP_ENV=dev \
	--build-arg APP_DEBUG=1 \
	--file ./docker/php-cli/Dockerfile \
	--tag sandbox/php-cli .

docker build \
  --build-arg APP_ENV=dev \
	--build-arg APP_DEBUG=1 \
	--file ./docker/php-fpm/Dockerfile \
	--tag sandbox/php-fpm .
