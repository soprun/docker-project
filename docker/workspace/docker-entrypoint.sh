#!/bin/sh

set -e

echo "Trying my-entrypoint with args: $@"

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- php-fpm "$@"
fi

## first arg is `-f` or `--some-option`
## or if our command is a valid wp-cli subcommand, let's invoke it through wp-cli instead
## (this allows for "docker run wordpress:cli help", etc)
#if [ "${1#-}" != "$1" ] || wp help "$1" > /dev/null 2>&1; then
#	set -- wp "$@"
#fi

#user='www-data'
#group='www-data'

user="$(id -u)"
group="$(id -g)"

echo $user
echo $group

# Run
exec "$@"
