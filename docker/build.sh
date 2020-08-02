#!/bin/sh

# clear -x
set -e

#loads env vars into this process
ENV="./.env"
if [ -e $ENV ]; then
  . $ENV
fi

# TODO: https://git-scm.com/docs/git-show
# git_author_email="$(git show -s --format=%ae)"

#set default for undefined vars
if [ -z "${APP_SECRET}" ]; then
  app_secret=$(openssl rand -hex 16)
  echo "Setting: secret to ${app_secret}"
fi
if [ -z "${APP_RELEASE}" ]; then
  app_release=$(git rev-parse --verify HEAD)
  echo "Setting release to ${app_release}"
fi
if [ -z "$DOCKER_CONTAINERS" ]; then
  DOCKER_CONTAINERS="nginx php-fpm"
  echo "Setting DOCKER_CONTAINERS to $DOCKER_CONTAINERS"
fi
if [ -z "$DOCKER_SHARED_PATH" ]; then
  DOCKER_SHARED_PATH="~/docker-data"
  echo "Setting DOCKER_SHARED_PATH to $DOCKER_SHARED_PATH"
fi
if [ -z "$DOCKER_PROJECT_PATH" ]; then
  DOCKER_PROJECT_PATH=${DOCKER_SHARED_PATH}/$(basename $(pwd))
  echo "Setting DOCKER_PROJECT_PATH to $DOCKER_PROJECT_PATH"
fi

#export all docker vars
export APP_SECRET="$app_secret"
export APP_RELEASE="$app_release"
export DOCKER_SHARED_PATH="$DOCKER_SHARED_PATH"
export DOCKER_PROJECT_PATH="$DOCKER_PROJECT_PATH"

printf '\e[0;31m%-6s\e[m\n' 'Docker running building contractors!'

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
  --tag sandbox/php \
  .

printf '\n\e[0;32m%-6s\e[m\n\n' 'Docker executed building!!'



# docker build -t sandbox/php-fpm:${DOCKER_PHP_VERSION} .
# and the latest tag also
# docker build -t sandbox/php-fpm .