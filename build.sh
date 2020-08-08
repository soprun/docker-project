#!/usr/bin/env bash

set -eo pipefail

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
### Application environment variables
###

if [ -z "${GIT_BRANCH}" ]; then
  export GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
fi

if [ -z "${GIT_COMMIT_SHA}" ]; then
  export GIT_COMMIT_SHA="$(git rev-parse HEAD)"
fi

if [ -z "${APP_SECRET}" ]; then
  export APP_SECRET="$(openssl rand -hex 16)"
fi

if [ -z "${APP_RELEASE}" ]; then
  export APP_RELEASE="${GIT_COMMIT_SHA}"
fi

set -u

log $(printenv | sort | less)
log_info "Docker running building contractors! 🐳 "

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --file ./docker/nginx/Dockerfile \
  --tag soprun/sandbox-nginx \
  .

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --file ./docker/php-cli/Dockerfile \
  --tag soprun/sandbox-php-cli \
  .

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --file ./docker/php/Dockerfile \
  --tag soprun/sandbox-php \
  .

log_info "Starting detached containers: 🐳 "

docker-compose --log-level info up \
  --detach \
  --force-recreate \
  --remove-orphans

# env -i TERM="$TERM" PATH="$PATH" USER="$USER" HOME="$HOME" sh

# command > /dev/null 2>&1 &
# Здесь >/dev/null 2>&1 обозначает, что stdout будет перенаправлен на /dev/null,
# а stderr — к stdout.
