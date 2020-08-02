#!/bin/sh

set -e

# first arg is `-f` or `--some-option`
if [[ "${1#-}" != "$1" ]]; then
	set -- php "$@"
fi

echo 'Linting PHP files'

if ! composer --version > /dev/null 2> /dev/null; then
    printf '\e[0;31m%-6s\e[m\n\n' 'Composer is not installed.'
fi

if ! composer global show hirak/prestissimo > /dev/null 2> /dev/null; then
  printf '\e[0;31m%-6s\e[m\n\n' 'Composer global package "hirak/prestissimo" is not installed.'
  composer global require hirak/prestissimo --quiet;
fi

if ! test -f ./vendor/autoload.php; then
    printf '\e[0;31m%-6s\e[m\n\n' 'Composer dependencies are not installed.'
fi

# Use the default production configuration
mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

if [ ${APP_ENV} = "dev" ]; then \
  mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
fi

php-fpm --nodaemonize
