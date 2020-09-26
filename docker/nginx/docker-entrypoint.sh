#!/bin/sh

set -e

log_info() {
  printf "=>\033[0;34m log.info: \033[0m%-6s\n" "$@"
  logger -p user.info -t "$SHELL_SCRIPT_NAME" "$@"
}

error() {
  printf "=>\033[0;31m log.error: \033[0m%-6s\n" "$@" >&2
  logger -p user.error -t "$SHELL_SCRIPT_NAME" "$@"
  exit 1
}

log_info "Checking PHP connection ..."

i=0
until [ $i -ge 10 ]; do
  nc -z php 9000 && break

  i=$((i + 1))

  log_info "$i: Waiting for PHP 2 second ..."
  sleep 2
done

if [ $i -eq 10 ]; then
  error "PHP connection refused, terminating ..."
fi

log_info "PHP is up ..."

exec "$@"
