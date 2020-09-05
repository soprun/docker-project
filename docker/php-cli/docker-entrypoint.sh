#!/usr/bin/env bash

set -euo pipefail
clear -x

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- php-cli "$@"
fi

## if our command is a valid wp-cli subcommand, let's invoke it through wp-cli instead
## (this allows for "docker run wordpress:cli help", etc)
#if wp --path=/dev/null help "$1" > /dev/null 2>&1; then
#	set -- wp "$@"
#fi

exec "$@"
