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

readonly SHELL_SCRIPT_PATH="$(pwd)"

if [ -e "${SHELL_SCRIPT_PATH}/.env" ]; then
  set -o allexport
  source "${SHELL_SCRIPT_PATH}/.env"
  set +o allexport
fi

if [ -e "${SHELL_SCRIPT_PATH}/.env.local" ]; then
  set -o allexport
  source "${SHELL_SCRIPT_PATH}/.env.local"
  set +o allexport
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

if [ -z "${APP_PATH}" ]; then
  export APP_PATH="$(pwd)"
fi

if [ -z "${APP_NAME}" ]; then
  export APP_NAME="$(basename ${APP_DIR})"
fi

if [ -z "${APP_SECRET}" ]; then
  export APP_SECRET="$(openssl rand -hex 16)"
fi

if [ -z "${APP_RELEASE}" ]; then
  export APP_RELEASE="$(git rev-parse --abbrev-ref HEAD)"
fi

if [ -z "${APP_COMMIT_SHA}" ]; then
  export APP_COMMIT_SHA="$(git rev-parse HEAD)"
fi

###
### Application environment variables
###

set -eux

log $(printenv | sort | less)
log_info "Docker running building contractors! 🐳 "

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --build-arg APP_RELEASE="${APP_RELEASE}" \
  --build-arg APP_COMMIT_SHA="${APP_COMMIT_SHA}" \
  --build-arg APP_SECRET="${APP_SECRET}" \
  --file ./docker/nginx/Dockerfile \
  --tag soprun/sandbox-nginx:latest \
  --push \
  .

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --build-arg APP_RELEASE="${APP_RELEASE}" \
  --build-arg APP_COMMIT_SHA="${APP_COMMIT_SHA}" \
  --build-arg APP_SECRET="${APP_SECRET}" \
  --file ./docker/php_cli/Dockerfile \
  --tag soprun/sandbox-php-cli:latest \
  --push \
  .

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --build-arg APP_RELEASE="${APP_RELEASE}" \
  --build-arg APP_COMMIT_SHA="${APP_COMMIT_SHA}" \
  --build-arg APP_SECRET="${APP_SECRET}" \
  --file ./docker/php/Dockerfile \
  --tag soprun/sandbox-php:latest \
  .

# env -i TERM="$TERM" PATH="$PATH" USER="$USER" HOME="$HOME" sh
