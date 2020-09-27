#!/bin/sh

set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- php-fpm "$@"
fi

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

check_connection() {
  printf "\nChecking connection ...\n"
  local i=0

  until [ $i -ge 20 ]; do
    nc -zv "$1" "$2" && break

    i=$((i + 1))

    printf "=> \033[0;31m%u\033[0m: Waiting for \033[0;34m%s:%u\033[0m 1 second ...\n" "$i" "$1" "$2"
    sleep 1
  done

  if [ $i -eq 20 ]; then
    printf "\033[0;31m%s\033[0m\n" "Connection refused, terminating ..."
    exit 1
  fi

  printf "\033[0;32m%s:%u\033[0m is up ...\n" "$1" "$2"
}

check_connection $POSTGRES_HOST $POSTGRES_PORT
check_connection $REDIS_HOST $REDIS_PORT

###
### Linting PHP
###

printf "\033[0;32m %-6s\033[0m\n" 'Linting PHP files 🗂.'

if ! composer --version >/dev/null 2>/dev/null; then
  log_info 'Composer is not installed.'
fi

if ! composer global show hirak/prestissimo >/dev/null 2>/dev/null; then
  log_info 'Composer "hirak/prestissimo" is not installed.'
fi

if ! test -f ./vendor/autoload.php; then
  log_info 'Composer dependencies are not installed.'
fi

###
### Startup
###

#log_info "Starting $(php-fpm -v 2>&1 | head -1)"
#log_info "Environment: ${APP_ENV}"
#log_info "Debug: ${APP_DEBUG}"
#log_info "Debug level: ${APP_DEBUG_LEVEL}"

# Check that platform requirements are satisfied.
#composer check-platform-reqs

exec docker-php-entrypoint "$@"
