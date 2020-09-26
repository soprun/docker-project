#!/bin/sh

set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- php-fpm "$@"
fi

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

exec docker-php-entrypoint "$@"
