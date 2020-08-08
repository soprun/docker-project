#!/usr/bin/env bash

# docker buildx use multibuilder
# docker buildx use default

source './docker/scripts/logger.sh'
source './docker/scripts/function.sh'

clear -x
set -e

# loads env vars into this process
load_env '.env'
load_env '.env.local'

if [ ! -z "${APP_ENV}" ]; then
  load_env ".env.${APP_ENV}"
  load_env ".env.${APP_ENV}.local"
fi

if [ -z "${DOCKER_DEBUG}" ]; then
  export DOCKER_DEBUG=false
fi

if [[ "${DOCKER_DEBUG}" == true || "${DOCKER_DEBUG}" -eq 1 ]]; then
  log 'Debugging mode is enabled!'
  set -xv
fi

# Set default for undefined vars

#if [ -z "$DOCKER_DETACHED_MODE" ]; then
#  DOCKER_DETACHED_MODE=true
#fi
#if [ -z "$DOCKER_BUILD" ]; then
#  DOCKER_BUILD=true
#fi
#if [ -z "$DOCKER_BUILD_CACHE" ]; then
#  DOCKER_BUILD_CACHE=true
#fi
#if [ -z "$DOCKER_CONTAINERS" ]; then
#  DOCKER_CONTAINERS="nginx php-fpm"
#fi
#if [ -z "$DOCKER_SHARED_PATH" ]; then
#  DOCKER_SHARED_PATH="~/docker-data"
#fi
#if [ -z "$DOCKER_PROJECT_PATH" ]; then
#  DOCKER_PROJECT_PATH=${DOCKER_SHARED_PATH}/$(basename $(pwd))
#fi

# export COMPOSE_PROJECT_NAME="${APP_NAME}"

# treat unset variables as an error
set -u

#export DOCKER_SHARED_PATH="$DOCKER_SHARED_PATH"
#export DOCKER_PROJECT_PATH="$DOCKER_PROJECT_PATH"

log "Export: docker environment variables ✅ "
log "DOCKER_DEBUG: ${DOCKER_DEBUG}"
#log "DOCKER_SHARED_PATH: ${DOCKER_SHARED_PATH}"
#log "DOCKER_PROJECT_PATH: ${DOCKER_PROJECT_PATH}"

if [ -z "${APP_SECRET}" ]; then
  APP_SECRET=$(openssl rand -hex 16)
fi
if [ -z "${APP_RELEASE}" ]; then
  APP_RELEASE=$(git rev-parse HEAD)
fi

export APP_SECRET="${APP_SECRET}"
export APP_RELEASE="${APP_RELEASE}"

log "Export: application environment variables ✅ "
log "APP_ENV: ${APP_ENV}"
log "APP_DEBUG: ${APP_DEBUG}"
log "APP_SECRET: ${APP_SECRET}"
log "APP_RELEASE: ${APP_RELEASE}"

log "Docker running building contractors! 🐳 "

docker build \
  --file ./docker/nginx/Dockerfile \
  --tag soprun/sandbox-nginx:latest \
  --push \
  .

docker build \
  --build-arg app_env=dev \
  --build-arg app_debug=1 \
  --file ./docker/php_cli/Dockerfile \
  --tag soprun/sandbox-php-cli:latest \
  --push \
  .

docker build \
  --build-arg app_env=dev \
  --build-arg app_debug=1 \
  --file ./docker/php/Dockerfile \
  --tag soprun/sandbox-php:latest \
  --push \
  .

if [[ "${DOCKER_DETACHED_MODE}" == true || "${DOCKER_DETACHED_MODE}" -eq 1 ]]; then
  log "Starting detached containers: 🐳 "

  docker-compose --log-level info up \
    --detach \
    --force-recreate \
    --remove-orphans

  # ${DOCKER_CONTAINERS}
else
  log "Starting attached containers: 🐳 "

  docker-compose --log-level info up \
    --force-recreate \
    --remove-orphans
fi

# command > /dev/null 2>&1 &
# Здесь >/dev/null 2>&1 обозначает, что stdout будет перенаправлен на /dev/null,
# а stderr — к stdout.
