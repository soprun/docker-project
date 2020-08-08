#!/bin/sh
clear -x
set -e

#if [[ -n "${APP_DEBUG}" ]]; then
#    set -x
#fi

# loads env vars into this process
env_file="./.env"

if [ -e $env_file ]; then
  . $env_file
fi

# TODO: https://git-scm.com/docs/git-show
# git_author_email="$(git show -s --format=%ae)"

# Set default for undefined vars
if [ -z "${APP_SECRET}" ]; then
  app_secret=$(openssl rand -hex 16)
fi
if [ -z "${APP_RELEASE}" ]; then
  app_release=$(git rev-parse HEAD)
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
  --file ./docker/php_cli/Dockerfile \
  --tag sandbox/php_cli \
  .

docker build \
  --build-arg app_env=dev \
  --build-arg app_debug=true \
  --file ./docker/php/Dockerfile \
  --tag sandbox/php \
  .

printf '\n\e[0;32m%-6s\e[m\n\n' 'Docker executed building!!'

# docker build -t sandbox/php-fpm:${DOCKER_PHP_VERSION} .
# and the latest tag also
# docker build -t sandbox/php-fpm .


if [ -z "$DOCKER_ATTACHED_MODE" ]; then
  echo "Starting detached containers:"
  docker-compose --log-level info up --detach --force-recreate --remove-orphans # ${DOCKER_CONTAINERS}
else
  echo "Starting attached containers:"
  docker-compose --log-level info up --force-recreate --remove-orphans # ${DOCKER_CONTAINERS}
fi

exit 0