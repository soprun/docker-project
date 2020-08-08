#!/bin/sh

set -e
set -o pipefail

clear -x

source "./docker/scripts/logger.sh"

###
### Check docker
###

if ! docker --version >/dev/null 2>/dev/null; then
  error 'Docker is not installed.'
fi

if ! docker-compose --version >/dev/null 2>/dev/null; then
  error 'Docker compose is not installed.'
fi

###
### Globals
###

# ${DOCKER_SRC}

readonly SHELL_SCRIPT_PATH="$(pwd)"

if [ -e "${SHELL_SCRIPT_PATH}/.env" ]; then
  source "${SHELL_SCRIPT_PATH}/.env"
fi

if [ -e "${SHELL_SCRIPT_PATH}/.env.local" ]; then
  source "${SHELL_SCRIPT_PATH}/.env.local"
fi

###
### Docker environment variables
###

#if [ -z "${DOCKER_DEBUG}" ]; then
#  export DOCKER_DEBUG=0
#fi
#
#if [ -z "${DOCKER_DETACHED_MODE}" ]; then
#  export DOCKER_DETACHED_MODE=1
#fi
#
#if [ -z "${DOCKER_PROJECT_PATH}"]; then
#  export DOCKER_PROJECT_PATH="$(pwd)"
#fi
#
# if [ -z "${DOCKER_PROJECT_NAME}" ]; then
#   export DOCKER_PROJECT_NAME="$(basename ${DOCKER_PROJECT_PATH})"
# fi
#
# export COMPOSE_PROJECT_NAME="${DOCKER_PROJECT_NAME}"

#if [ -z "${APP_PATH}" ]; then
#  export APP_PATH="$(pwd)"
#fi
#
#if [ -z "${APP_NAME}" ]; then
#  export APP_NAME="$(basename $(pwd))"
#fi

if [ -z "${APP_SECRET}" ]; then
  export APP_SECRET="$(openssl rand -hex 16)"
fi

if [ -z "${GIT_BRANCH}" ]; then
  export GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
fi

if [ -z "${GIT_COMMIT_SHA}" ]; then
  export GIT_COMMIT_SHA="$(git rev-parse HEAD)"
fi

###
### Application environment variables
###

dump_env

set -u

log $(printenv | sort | less)
log_info "Docker running building contractors! 🐳 "

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --file ./docker/nginx/Dockerfile \
  --tag soprun/sandbox-nginx:latest \
  .

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --file ./docker/php_cli/Dockerfile \
  --tag soprun/sandbox-php-cli:latest \
  .

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --file ./docker/php/Dockerfile \
  --tag soprun/sandbox-php:latest \
  .

# env -i TERM="$TERM" PATH="$PATH" USER="$USER" HOME="$HOME" sh

log_info "Docker push images: 🐳 "

docker push soprun/sandbox-nginx
docker push soprun/sandbox-php
docker push soprun/sandbox-php-cli

log_info "Starting detached containers: 🐳 "

docker-compose --log-level info up \
  --detach \
  --force-recreate \
  --remove-orphans

# command > /dev/null 2>&1 &
# Здесь >/dev/null 2>&1 обозначает, что stdout будет перенаправлен на /dev/null,
# а stderr — к stdout.
