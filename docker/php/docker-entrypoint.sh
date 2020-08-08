#!/bin/sh

set -e
set -u
set -o pipefail

# clear -x

###
### Globals
###

############################################################
# Functions
############################################################

readonly SHELL_SCRIPT_NAME=$(basename $0)

function log() {
  logger -p user.debug -t $SHELL_SCRIPT_NAME "$@"
}

function log_success() {
  printf "=>\033[0;32m log.info: \033[0m%-6s\n" "$@"
  logger -p user.info -t $SHELL_SCRIPT_NAME "$@"
}

function log_info() {
  printf "=>\033[0;34m log.info: \033[0m%-6s\n" "$@"
  logger -p user.info -t $SHELL_SCRIPT_NAME "$@"
}

function error() {
  printf "=>\033[0;31m log.error: \033[0m%-6s\n" "$@" >&2
  logger -p user.error -t $SHELL_SCRIPT_NAME "$@"
  exit 1
}

###
### Linting PHP
###

printf "=>\033[0;32m %-6s\033[0m\n" 'Linting PHP files 🗂.'

if ! composer --version >/dev/null 2>/dev/null; then
  error 'Composer is not installed.'
fi

if ! composer global show hirak/prestissimo >/dev/null 2>/dev/null; then
  error 'Composer "hirak/prestissimo" is not installed.'

  # Start it in the background
  # composer global require hirak/prestissimo --ignore-platform-reqs >/dev/null 2>&1
  # log_info 'Composer "hirak/prestissimo" is installed.'
fi

if ! test -f ./vendor/autoload.php; then
  printf '\e[0;31m%-6s\e[m\n' 'Composer dependencies are not installed.'
fi

###
### Startup
###
log_info "Starting $(php-fpm -v 2>&1 | head -1)"
log_info "Environment: ${APP_ENV}"
log_info "Debug: ${APP_DEBUG}"
log_info "Debug level: ${APP_DEBUG_LEVEL}"

exec "${@}"
