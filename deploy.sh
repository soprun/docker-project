#!/usr/bin/env bash

set -euo pipefail

log() {
  logger -p user.debug -t "$(basename "${0}")" "$@"
}

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

warn() {
  printf "=>\033[0;33m warn: \033[0m%-6s\n" "$*"
  logger -p user.warn -t "$(basename "${0}")" "$@"
}

error() {
  printf "=>\033[0;31m error: \033[0m%-6s\n" "$*" >&2
  logger -p user.error -t "$(basename "${0}")" "$@"
  exit 1
}

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
if [ -z "${PROJECT_NAME:-}" ]; then
  PROJECT_NAME="$(basename "$BUILD_DIR")"
  export PROJECT_NAME
fi

#echo $BUILD_DIR
#echo $PROJECT_NAME
#printenv | sort

docker build \
  --file ./docker/php-cli/Dockerfile \
  --tag "soprun/sandbox-php-cli:latest" \
  .
