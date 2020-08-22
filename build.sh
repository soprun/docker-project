#!/usr/bin/env bash

set -eo pipefail

source "./.backup/logger.sh"

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

# 1. Check if .env file exists
if [ -e .env ]; then
  # shellcheck source=./.env
  source .env
fi

# 2. Check if .env.local file exists
if [ -e .env.local ]; then
  # shellcheck source=./.env.local
  source .env.local
fi

#if [ -e "${SHELL_SCRIPT_PATH}/.env" ]; then
#  set -o allexport
#  # shellcheck source=./.env
#  source "${SHELL_SCRIPT_PATH}/.env"
#  set +o allexport
#fi
#
#if [ -e "${SHELL_SCRIPT_PATH}/.env.local" ]; then
#  set -o allexport
#  # shellcheck source=./.env.local
#  source "${SHELL_SCRIPT_PATH}/.env.local"
#  set +o allexport
#fi

###
### Create default network
###

# docker network remove "$NETWORK_NAME" 2>/dev/null

if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>/dev/null; then
  log_info 'Network is not installed.'

  docker network create "$NETWORK_OPTIONS" "$NETWORK_NAME"
fi

###
### Application environment variables
###

if [ -z "${GIT_BRANCH}" ]; then
  GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
fi

if [ -z "${GIT_COMMIT_SHA}" ]; then
  GIT_COMMIT_SHA="$(git rev-parse HEAD)"
fi

if [ -z "${APP_SECRET}" ]; then
  APP_SECRET="$(openssl rand -hex 16)"
fi

if [ -z "${APP_RELEASE}" ]; then
  APP_RELEASE="${GIT_COMMIT_SHA}"
fi

export GIT_BRANCH
export GIT_COMMIT_SHA
export APP_SECRET
export APP_RELEASE

set -u

log $(printenv | sort | less)
log_info "Docker running building contractors! 🐳 "

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --file ./docker/nginx/Dockerfile \
  --tag soprun/sandbox-nginx \
  .

#docker build \
#  --build-arg APP_ENV="${APP_ENV}" \
#  --build-arg APP_DEBUG="${APP_DEBUG}" \
#  --file ./docker/php-cli/Dockerfile \
#  --tag soprun/sandbox-php-cli:dev \
#  --tag soprun/sandbox-php-cli:latest \
#  --target dev \
#  .
#
#docker build \
#  --build-arg APP_ENV="${APP_ENV}" \
#  --build-arg APP_DEBUG="${APP_DEBUG}" \
#  --file ./docker/php-cli/Dockerfile \
#  --tag soprun/sandbox-php-cli:prod \
#  --target prod \
#  .

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --file ./docker/php/Dockerfile \
  --tag soprun/sandbox-php:latest \
  --tag "soprun/sandbox-php:${GIT_BRANCH}" \
  --tag "soprun/sandbox-php:${GIT_COMMIT_SHA}" \
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

# git commit -a -S -m "build image: ${APP_RELEASE}"

#main() {
#  bash "${BATS_TEST_DIRNAME}"/package-tarball
#}



# symfony server:ca:install