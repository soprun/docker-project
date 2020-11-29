#######################################################################
# Installation base container
#######################################################################

FROM php:8.0-rc-fpm-alpine AS builder

#######################################################################
# Default environment variables
#######################################################################

ENV APP_ENV prod
ENV APP_DEBUG 0
ENV APP_SECRET default-secret

ENV PATH "${APP_DIR}/bin:$PATH"
ENV PATH "${APP_DIR}/vendor/bin:$PATH"

ENV TZ UTC
ENV LANG en_US.UTF8
ENV LANGUAGE en

#######################################################################
# Install software and utilities
#######################################################################

# persistent dependencies
RUN apk add --no-cache \
  curl \
  bash \
  git \
  vim \
  unzip

#######################################################################
# Install PHP extensions
#######################################################################

#COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
#RUN install-php-extensions \
#  intl \
#  opcache \
#  apcu \
#  redis

#######################################################################
# Default configuration
#######################################################################

COPY ./docker/php/conf.d/* "${PHP_INI_DIR}/conf.d/"
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

# Use the default development configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

#######################################################################
# Install composer & composer plugins
#######################################################################

#ENV COMPOSER_HOME "/composer"
#ENV COMPOSER_CACHE_DIR "${COMPOSER_HOME}/cache"
#ENV PATH "${COMPOSER_HOME}/vendor/bin:$PATH"

ENV COMPOSER_MEMORY_LIMIT -1
ENV COMPOSER_ALLOW_SUPERUSER 1

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install composer plugin
RUN composer global require hirak/prestissimo \
  --no-progress \
  --no-scripts \
  --no-interaction \
  --ignore-platform-reqs \
  --optimize-autoloader \
  --classmap-authoritative \
  --profile

# Set the working directory.
WORKDIR /app

#######################################################################
# Copying & install application dependencies
#######################################################################

COPY ./app/composer.* /app
COPY ./app/symfony.lock /app

### Install application dependencies
RUN composer install \
  --no-progress \
  --no-scripts \
  --no-interaction \
  --prefer-dist \
  --optimize-autoloader \
  --classmap-authoritative \
  --profile

# Copying source files to workdir

COPY ./app/bin /app/bin
COPY ./app/config /app/config
COPY ./app/public /app/public
COPY ./app/src /app/src
COPY ./app/templates /app/templates
COPY ./app/.env /app/.env

RUN set -e; \
  composer dump-autoload --classmap-authoritative; \
  mkdir -p /app/var; \
  chown -R www-data:www-data /app; \
  chmod -R 777 /app/var

CMD php-fpm

EXPOSE 9000
