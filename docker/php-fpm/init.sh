#!/bin/sh

# first arg is `-f` or `--some-option`
if [[ "${1#-}" != "$1" ]]; then
	set -- php "$@"
fi

set -o errexit
set -o nounset

echo 'Linting PHP files'

if ! composer --version > /dev/null 2> /dev/null; then
    printf '\e[0;31m%-6s\e[m\n\n' 'Composer is not installed.'
fi

if ! test -f ./vendor/autoload.php; then
    printf '\e[0;31m%-6s\e[m\n\n' 'Composer dependencies are not installed.'
fi

php-fpm --nodaemonize
