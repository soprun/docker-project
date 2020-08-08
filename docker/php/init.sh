#!/bin/sh

set -e

# first arg is `-f` or `--some-option`
if [[ "${1#-}" != "$1" ]]; then
  set -- php "$@"
fi

printf '\e[0;31m%-6s\e[m\n\n' "Linting PHP files.";

if ! composer --version >/dev/null 2>/dev/null; then
  printf '\e[0;31m%-6s\e[m\n' 'Composer is not installed.';
fi

if ! composer global show hirak/prestissimo >/dev/null 2>/dev/null; then
  printf '\e[0;31m%-6s\e[m\n' 'Composer "hirak/prestissimo" is not installed.'
  # composer global require hirak/prestissimo
  # printf '\e[0;32m%-6s\e[m\n' 'Composer "hirak/prestissimo" is installed.'
fi

if ! test -f ./vendor/autoload.php; then
  printf '\e[0;31m%-6s\e[m\n' 'Composer dependencies are not installed.'
fi

if ! test -f "${PHP_INI_DIR}/php.ini"; then
  php_config_file="php.ini-development"

  if [ ${APP_ENV} = "prod" ]; then
    php_config_file="php.ini-production"
  fi

  # mv "$PHP_INI_DIR/${php_config_file}" "${PHP_INI_DIR}/php.ini"
  printf '\e[0;32m%-6s\e[m\n' "PHP default configuration installed: \"${php_config_file}\"."
fi

# php --version
# composer --version

# composer check-platform-reqs
# composer install --no-suggest --no-interaction --prefer-dist --optimize-autoloader

clear -x
printf '\e[0;32m%-6s\e[m\n\n' "Successful deployment.";

php-fpm --nodaemonize;
