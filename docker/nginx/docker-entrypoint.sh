#!/bin/sh

set -e

check_connection() {
  printf "\nChecking connection ...\n"
  local i=0

  until [ $i -ge 20 ]; do
    nc -z "$1" "$2" && break

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

check_connection php 9000

exec "$@"
