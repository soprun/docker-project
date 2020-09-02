#!/usr/bin/env bash

set -euox pipefail

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

if ! mkcert --version >/dev/null 2>/dev/null; then
  error 'mkcert is not installed.'
fi

if ! openssl version >/dev/null 2>/dev/null; then
  error 'openssl is not installed.'
fi

###
### Globals
###

# readonly SHELL_SCRIPT_PATH="$(dirname "$(readlink "$BASH_SOURCE")")"
# cd "$SHELL_SCRIPT_PATH"

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

###
### Create default network
###

#docker network remove "$NETWORK_NAME"  >/dev/null 2>&1

if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>/dev/null; then
  log_info 'Network is not installed.'

  docker network create "$NETWORK_OPTIONS" "$NETWORK_NAME"
fi

readonly NGINX_SSL_PATH="./docker/nginx/ssl"

if [ ! -e "$NGINX_SSL_PATH/key.pem" ]; then
  log_info 'Create locally-trusted development certificate.'

  mkcert \
    -key-file "$NGINX_SSL_PATH/key.pem" \
    -cert-file "$NGINX_SSL_PATH/cert.pem" \
    "$APP_HOST" "*.$APP_HOST" localhost 127.0.0.1 ::1
fi

if [ ! -e "$NGINX_SSL_PATH/dhparam.pem" ]; then
  log_info "Create Diffie-Hellman 🔐"

  openssl dhparam -out "$NGINX_SSL_PATH/dhparam.pem" 1024 >/dev/null 2>&1
fi

###
### Application environment variables
###

if [ -z "${GIT_TAG:-}" ]; then
  GIT_TAG="$(git describe --tags --abbrev=0)"
fi

if [ -z "${GIT_BRANCH:-}" ]; then
  GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
fi

if [ -z "${GIT_COMMIT_ID:-}" ]; then
  GIT_COMMIT_ID="$(git rev-parse --short HEAD)"
fi

if [ -z "${GIT_COMMIT_SHA:-}" ]; then
  GIT_COMMIT_SHA="$(git rev-parse HEAD)"
fi

if [ -z "${APP_SECRET:-}" ]; then
  APP_SECRET="$(openssl rand -hex 16)"
fi

if [ -z "${APP_RELEASE:-}" ]; then
  APP_RELEASE="${GIT_COMMIT_SHA}"
fi

export GIT_BRANCH=${GIT_BRANCH}
export GIT_COMMIT_ID=${GIT_COMMIT_ID}
export GIT_COMMIT_SHA=${GIT_COMMIT_SHA}
export APP_ENV=${APP_ENV}
export APP_DEBUG=${APP_DEBUG}
export APP_SECRET=${APP_SECRET}
export APP_RELEASE=${APP_RELEASE}

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
  --tag "soprun/sandbox-php:latest" \
  --tag "soprun/sandbox-php:${GIT_BRANCH}" \
  --tag "soprun/sandbox-php:${GIT_COMMIT_SHA}" \
  .

log_info "Starting detached containers: 🐳 "

docker-compose --log-level info up \
  --detach \
  --force-recreate \
  --remove-orphans

log_info '=> Docker push images: 🐳 '

#docker push soprun/sandbox-nginx
#docker push soprun/sandbox-php
#docker push soprun/sandbox-php-cli

# docker exec -ti php sh

# env -i TERM="$TERM" PATH="$PATH" USER="$USER" HOME="$HOME" sh

# command > /dev/null 2>&1 &
# Здесь >/dev/null 2>&1 обозначает, что stdout будет перенаправлен на /dev/null,
# а stderr — к stdout.

# git commit -a -S -m "build image: ${APP_RELEASE}"

# docker buildx bake -f ./docker/php/Dockerfile

#main() {
#  bash "${BATS_TEST_DIRNAME}"/package-tarball
#}

# symfony server:ca:install

#symfony composer req logger
#symfony composer req debug --dev
#
#symfony composer req maker --dev
#symfony console list make
#
#symfony composer req annotations
#symfony composer req orm
#
