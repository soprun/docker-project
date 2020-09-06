#!/usr/bin/env bash

set -euo pipefail

success() {
  printf "=>\033[0;32m log: \033[0m%-6s\n" "$*"
  logger -p user.info -t "$(basename "${0}")" "$@"
  sleep .2
}

info() {
  printf "=>\033[0;34m log: \033[0m%-6s\n" "$*"
  logger -p user.info -t "$(basename "${0}")" "$@"
  sleep .2
}

error() {
  printf "=>\033[0;31m error: \033[0m%-6s\n" "$*" >&2
  logger -p user.error -t "$(basename "${0}")" "$@"
  exit 1
}

success 'Linting dependencies & utilities 🗂.'

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

if ! shellcheck --version >/dev/null 2>/dev/null; then
  error 'shellcheck is not installed.'
fi

# Determine the build script's actual directory, following symlinks
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  SOURCE="$(readlink "$SOURCE")"
done

BUILD_DIR="$(cd -P "$(dirname "${SOURCE}")" && pwd)"

# Load environment variables
if [ -e "${BUILD_DIR}/.env" ]; then
  set -o allexport
  #shellcheck source=./.env
  source "${BUILD_DIR}/.env"
  set +o allexport
fi

# Derive the project name from the directory
if [ -z "${PROJECT_NAME}" ]; then
  PROJECT_NAME="$(basename "${BUILD_DIR}")"
  export PROJECT_NAME
fi

#error "$(printenv | sort | less)"

docker build \
  --file ./docker/nginx/Dockerfile \
  --tag "soprun/sandbox-nginx:latest" \
  .

docker build \
  --file ./docker/php/Dockerfile \
  --tag "soprun/sandbox-php:latest" \
  .

info 'Starting detached containers: 🐳 '
docker-compose up --detach --force-recreate --remove-orphans

info 'Docker push images: 🚢 '
docker push soprun/sandbox-nginx
docker push soprun/sandbox-php
success 'Docker push images is succeeded!'

# success code
exit 0
