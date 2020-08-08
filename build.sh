#!/usr/bin/env bash

# set -e
# set -o pipefail

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

SHELL_PATH="$(pwd)"

if [ -e "${SHELL_PATH}/.env" ]; then
  . "${SHELL_PATH}/.env"
fi

if [ -e "${SHELL_PATH}/.env.local" ]; then
  . "${SHELL_PATH}/.env.local"
fi

###
### Docker environment variables
###

if [ -z "${DOCKER_DEBUG}" ]; then
  readonly DOCKER_DEBUG=0
fi
if [ -z "${DOCKER_DETACHED_MODE}" ]; then
  readonly DOCKER_DETACHED_MODE=1
fi

if [ -z "${DOCKER_PROJECT_PATH}"]; then
  readonly DOCKER_PROJECT_PATH="$(pwd)"
fi

# if [ -z "${DOCKER_PROJECT_NAME}" ]; then
#   readonly DOCKER_PROJECT_NAME="$(basename ${DOCKER_PROJECT_PATH})"
# fi

# export COMPOSE_PROJECT_NAME="${DOCKER_PROJECT_NAME}"

if [ -z "${APP_NAME}" ]; then
  readonly APP_NAME="$(basename $(pwd))"
fi

if [ -z "${APP_SECRET}" ]; then
  readonly APP_SECRET="$(openssl rand -hex 16)"
fi

if [ -z "${APP_RELEASE}" ]; then
  readonly APP_RELEASE="$(git rev-parse --abbrev-ref HEAD)"
fi

if [ -z "${APP_COMMIT_SHA}" ]; then
  readonly APP_COMMIT_SHA="$(git rev-parse HEAD)"
fi

###
### Application environment variables
###

set -u

printenv | sort | less >> ./var/log/env.log

# printenv | grep ID
# printenv | grep APP_

#echo $PATH;

#
