#!/usr/bin/env bash

set -euo pipefail
clear -x

# source "./.backup/logger.sh"
# $(date)

#
# logger -p user.info -t "${BASH_SOURCE}" "$@"
# logger -p user.warn -t "${BASH_SOURCE}" "$@"

info() {
  printf "=>\033[0;34m log.info: \033[0m%-6s\n" "$@"
  logger -p user.info -t "$(basename "${0}")" "$@"
}

warn() {
  printf "=>\033[0;33m log.warn: \033[0m%-6s\n" "$@"
  logger -p user.warn -t "$(basename "${0}")" "$@"
}

error() {
  printf "=>\033[0;31m log.error: \033[0m%-6s\n" "$@" >&2
  logger -p user.error -t "$(basename "${0}")" "$@"
  exit 1
}

info 'info'
warn 'warn'
error 'error'

exit 0

###
### Check docker
###

if ! docker --version >/dev/null 2>/dev/null; then
  error 'docker is not installed.'
fi

if ! docker-compose --version >/dev/null 2>/dev/null; then
  error 'docker-compose is not installed.'
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

APP_DOCUMENT_ROOT="$(dirname "$(readlink "$BASH_SOURCE")")"
export APP_DOCUMENT_ROOT

# 1. Check if .env file exists
if [ -e "${APP_DOCUMENT_ROOT}/.env" ]; then
  # set -o allexport
  # shellcheck source=./.env
  source "${APP_DOCUMENT_ROOT}/.env"
  # set +o allexport
fi

# 2. Check if .env.local file exists
if [ -e "${APP_DOCUMENT_ROOT}/.env.local" ]; then
  # set -o allexport
  # shellcheck source=./.env.local
  source "${APP_DOCUMENT_ROOT}/.env.local"
  # set +o allexport
fi

###
### Create default network
###

if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>/dev/null; then
  log_info 'Network is not installed.'

  docker network create "$NETWORK_OPTIONS" "$NETWORK_NAME"
fi

readonly nginx_ssl_dir="./docker/nginx/ssl"

if [ ! -e "$nginx_ssl_dir/key.pem" ]; then
  log_info 'Create locally-trusted development certificate.'

  mkcert \
    -key-file "$nginx_ssl_dir/key.pem" \
    -cert-file "$nginx_ssl_dir/cert.pem" \
    "$APP_HOST" "*.$APP_HOST" localhost 127.0.0.1 ::1
fi

if [ ! -e "$nginx_ssl_dir/dhparam.pem" ]; then
  log_info "Create Diffie-Hellman 🔐"

  openssl dhparam -out "$nginx_ssl_dir/dhparam.pem" 1024 >/dev/null 2>&1
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

if [ -z "${GIT_COMMIT_SHA:-}" ]; then
  GIT_COMMIT_SHA="${GIT_COMMIT_SHA}"
fi

if [ -z "${APP_SECRET:-}" ]; then
  APP_SECRET="$(openssl rand -hex 16)"
fi

export APP_DIR=${APP_DIR}
export APP_ENV=${APP_ENV}
export APP_DEBUG=${APP_DEBUG}
export APP_SECRET=${APP_SECRET}

export GIT_TAG=${GIT_TAG}
export GIT_BRANCH=${GIT_BRANCH}
export GIT_COMMIT_ID=${GIT_COMMIT_ID}
export GIT_COMMIT_SHA=${GIT_COMMIT_SHA}

log_info "$(printenv | sort | less)"
log_info "Docker running building contractors! 🐳 "

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --file ./docker/nginx/Dockerfile \
  --tag "soprun/sandbox-nginx:latest" \
  --tag "soprun/sandbox-nginx:${GIT_BRANCH}" \
  --tag "soprun/sandbox-nginx:${GIT_COMMIT_SHA}" \
  .

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --file ./docker/php-cli/Dockerfile \
  --tag soprun/sandbox-php-cli:dev \
  --tag soprun/sandbox-php-cli:latest \
  --target dev \
  .

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

docker push soprun/sandbox-nginx
docker push soprun/sandbox-php
docker push soprun/sandbox-php-cli

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
