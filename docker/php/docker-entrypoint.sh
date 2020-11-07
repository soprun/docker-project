#!/bin/bash

set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- php-fpm "$@"
fi

log_info() {
  printf "\033[0;34m[info]\033[0m: %s\\n" "$1"
}

log_success() {
  printf "\033[0;32m[success]\033[0m: %s\\n" "$1"
}

log_error() {
  printf "\033[0;31m[error]\033[0m: %s\\n" "$1"
}

log_success 'Checking of environment variables. 🗂.'

log_info $APP_ENV
log_info $APP_DEBUG
log_info $APP_HOST
log_info $APP_SCHEME
log_info $APP_SECURE

exec docker-php-entrypoint "$@"
