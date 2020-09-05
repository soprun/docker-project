#!/usr/bin/env bash

set -euo pipefail

clear
tput sgr0

# echo "$(date "+%Y.%m.%d %H:%M:%S")"
# 2020.09.03 00:34:42

log() {
  logger -p user.debug -t "$(basename "${0}")" "$@"
}

success() {
  printf "=>\033[0;32m log: \033[0m%-6s\n" "$*"
  logger -p user.info -t "$(basename "${0}")" "$@"
  sleep .3
}

info() {
  printf "=>\033[0;34m log: \033[0m%-6s\n" "$*"
  logger -p user.info -t "$(basename "${0}")" "$@"
  sleep .3
}

warn() {
  printf "=>\033[0;33m warn: \033[0m%-6s\n" "$*"
  logger -p user.warn -t "$(basename "${0}")" "$@"
}

error() {
  printf "=>\033[0;31m error: \033[0m%-6s\n" "$*" >&2
  logger -p user.error -t "$(basename "${0}")" "$@"
  exit 1
}

# see: https://apple.stackexchange.com/questions/256769/how-to-use-logger-command-on-sierra
#log 'log'
#success 'success'
#info 'info'
#error 'error'

# log show --style compact --info --debug --predicate 'process == "logger"' --last 20m
# log stream --process logger --level debug --style syslog

###
### Check docker
###

info 'Check system required dependencies'

if ! docker --version >/dev/null 2>/dev/null; then
  error 'Command "docker" is not installed.'
fi

if ! docker-compose --version >/dev/null 2>/dev/null; then
  error 'Command "docker-compose" is not installed.'
fi

if ! git --version >/dev/null 2>/dev/null; then
  error 'Command "git-flow" is not installed.'
fi

if ! git-flow version >/dev/null 2>/dev/null; then
  error 'Command "git-flow" is not installed.'
fi

if ! mkcert --version >/dev/null 2>/dev/null; then
  error 'Command "mkcert" is not installed.'
fi

if ! openssl version >/dev/null 2>/dev/null; then
  error 'Command "openssl" is not installed.'
fi

if ! shellcheck --version >/dev/null 2>/dev/null; then
  error 'Command "shellcheck" is not installed.'
fi

success 'Check system required dependencies - is succeeded!'

###
### Globals
###

info 'Load environment variables'

# 1. Check if .env file exists
if [ -e .env ]; then
  # shellcheck source=./.env
  source .env
fi

success 'Load environment variables - is succeeded!'

###
### Application environment variables
###

info 'Check application environment variables'

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

success 'Check application environment variables - is succeeded!'
log "$(printenv | sort | less)"
set -u

###
### Create default network
###

info 'Check network'

if ! docker network inspect "${NETWORK_NAME}" >/dev/null 2>/dev/null; then
  warn "Network ${NETWORK_NAME} is not create."
  docker network create "${NETWORK_OPTIONS}" "${NETWORK_NAME}"
fi

success 'Check network - is succeeded!'

###
### SSL certificate
###

info 'Check SSL certificate'

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

success 'Check SSL certificate - is succeeded!'

info "Docker running building contractors! 🐳 "

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --file ./docker/nginx/Dockerfile \
  --tag "soprun/sandbox-nginx:latest" \
  --tag "soprun/sandbox-nginx:${GIT_BRANCH}" \
  --tag "soprun/sandbox-nginx:${GIT_COMMIT_ID}" \
  .

success 'Build sandbox-nginx - is succeeded!'

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --file ./docker/php-cli/Dockerfile \
  --tag "soprun/sandbox-php-cli:latest" \
  --tag "soprun/sandbox-php-cli:${GIT_BRANCH}" \
  --tag "soprun/sandbox-php-cli:${GIT_COMMIT_ID}" \
  .

success 'Build sandbox-php-cli - is succeeded!'

docker build \
  --build-arg APP_ENV="${APP_ENV}" \
  --build-arg APP_DEBUG="${APP_DEBUG}" \
  --file ./docker/php/Dockerfile \
  --tag "soprun/sandbox-php:latest" \
  --tag "soprun/sandbox-php:${GIT_BRANCH}" \
  --tag "soprun/sandbox-php:${GIT_COMMIT_ID}" \
  .

success 'Build sandbox-php - is succeeded!'

info "Starting detached containers: 🐳 "

docker-compose --log-level info up \
  --detach \
  --force-recreate \
  --remove-orphans

info '=> Docker push images: 🐳 '

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
