#!/usr/bin/env bash

set -euo pipefail
clear -x

###
### Globals
###

echo "Checking DB connection ..."

i=0
until [ $i -ge 10 ]; do
  nc -z "$POSTGRES_HOST" "$POSTGRES_PORT" && break

  i=$((i + 1))

  echo "$i: Waiting for DB 1 second ..."
  sleep 1
done

if [ $i -eq 10 ]; then
  echo "DB connection refused, terminating ..."
  exit 1
fi

echo "DB is up ..."

############################################################
# Functions
############################################################

readonly SHELL_SCRIPT_NAME=$(basename "$0")

log() {
  logger -p user.debug -t "$SHELL_SCRIPT_NAME" "$@"
}

log_success() {
  printf "=>\033[0;32m log.info: \033[0m%-6s\n" "$@"
  logger -p user.info -t "$SHELL_SCRIPT_NAME" "$@"
}

log_info() {
  printf "=>\033[0;34m log.info: \033[0m%-6s\n" "$@"
  logger -p user.info -t "$SHELL_SCRIPT_NAME" "$@"
}

error() {
  printf "=>\033[0;31m log.error: \033[0m%-6s\n" "$@" >&2
  logger -p user.error -t "$SHELL_SCRIPT_NAME" "$@"
  exit 1
}

###
### Linting PHP
###

printf "=>\033[0;32m %-6s\033[0m\n" 'Linting PHP files 🗂.'

if ! composer --version >/dev/null 2>/dev/null; then
  error 'Composer is not installed.'
fi

#if ! composer global show hirak/prestissimo >/dev/null 2>/dev/null; then
#  log_info 'Composer "hirak/prestissimo" is not installed.'
#
#  # Start it in the background
#  composer global require hirak/prestissimo \
#    --ignore-platform-reqs \
#    --quiet \
#    --profile
#
#  log_info 'Composer "hirak/prestissimo" is installed.'
#fi

if ! test -f ./vendor/autoload.php; then
  log_info 'Composer dependencies are not installed.'
fi

###
### Startup
###
log_info "Starting $(php-fpm -v 2>&1 | head -1)"
log_info "Environment: ${APP_ENV}"
log_info "Debug: ${APP_DEBUG}"
log_info "Debug level: ${APP_DEBUG_LEVEL}"

exec "${@}"
