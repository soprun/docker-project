#!/usr/bin/env bash

source ./docker/scripts/logger.sh

set -eu


#docker build \
#  --file ./docker/nginx/Dockerfile \
#  --tag soprun/sandbox-nginx \
#  .
#
#docker build \
#  --build-arg app_env=dev \
#  --build-arg app_debug=true \
#  --file ./docker/php_cli/Dockerfile \
#  --tag soprun/sandbox-php-cli \
#  .
#
#docker build \
#  --build-arg app_env=dev \
#  --build-arg app_debug=true \
#  --file ./docker/php/Dockerfile \
#  --tag soprun/sandbox-php \
#  .
#
#docker push soprun/sandbox-nginx
#docker push soprun/sandbox-php
#docker push soprun/sandbox-php-cli
#
## - docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_PASSWORD
## - docker build -t <my.container.registry.io>/<my_app>:<my_tag> .
## - docker push <my.container.registry.io>/<my_app>:<my_tag>
##

##!/bin/bash
#trap "echo Goodbye..." EXIT
#count=1
#while [ $count -le 5 ]
#do
#echo "Loop #$count"
#sleep 1
#count=$(( $count + 1 ))
#done

set -e

function progress() {
  echo -"$0: Please wait..."

  local job=$1
  echo $job
}

# Start it in the background
# progress

docker build \
  --file ./docker/nginx/Dockerfile \
  --tag soprun/sandbox-nginx:latest \
  --push \
  . \
  > /dev/null

docker build \
  --build-arg app_env=dev \
  --build-arg app_debug=1 \
  --file ./docker/php/Dockerfile \
  --tag soprun/sandbox-php:latest \
  --push \
  . \
  > /dev/null