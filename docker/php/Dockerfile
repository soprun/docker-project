# syntax=docker/dockerfile:experimental

#######################################################################
# Installation base container
#######################################################################

FROM php:8.0-rc-fpm-alpine AS base

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
RUN --mount=type=cache,target=/var/cache/apk \
  ln -s /var/cache/apk /etc/apk/cache && apk update && apk add \
  build-base \
  curl \
  bash \
  git \
  vim \
  unzip

#######################################################################
# Install PHP extensions
#######################################################################

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN --mount=type=cache,target=/var/cache/apk \
  install-php-extensions \
  intl \
  opcache \
  apcu \
  redis

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

ENV COMPOSER_HOME "/composer"
ENV COMPOSER_CACHE_DIR "${COMPOSER_HOME}/cache"
ENV PATH "${COMPOSER_HOME}/vendor/bin:$PATH"
ENV COMPOSER_MEMORY_LIMIT -1
ENV COMPOSER_ALLOW_SUPERUSER 1

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install composer plugin
RUN --mount=type=cache,target=/composer composer global require hirak/prestissimo \
  --no-progress \
  --no-scripts \
  --no-interaction \
  --ignore-platform-reqs \
  --optimize-autoloader \
  --classmap-authoritative \
  --profile

# Set the working directory.
WORKDIR /app

CMD php-fpm

EXPOSE 9000

#######################################################################
# Source container
#######################################################################

FROM base as src

#######################################################################
# Copying & install application dependencies
#######################################################################

COPY ./app/composer.* /app
COPY ./app/symfony.lock /app

### Install application dependencies
RUN --mount=type=cache,target=/composer composer install \
  --no-dev \
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
  # Finish composer
  composer dump-autoload --no-scripts --no-dev --optimize --classmap-authoritative; \
  mkdir -p /app/var; \
  chown -R www-data:www-data /app; \
  chmod -R 777 /app/var

#######################################################################
# Development container
#######################################################################

FROM src as dev

ENV APP_ENV dev
ENV APP_DEBUG 1

### Install application dependencies
RUN --mount=type=cache,target=/composer composer install \
  --no-progress \
  --no-scripts \
  --no-interaction \
  --prefer-dist \
  --optimize-autoloader \
  --classmap-authoritative \
  --profile

#######################################################################
# Production container
#######################################################################

FROM src as prod

ENV APP_ENV prod
ENV APP_DEBUG 0