# syntax=docker/dockerfile:experimental
FROM composer:latest as vendor

ENV COMPOSER_HOME "/composer"
ENV COMPOSER_CACHE_DIR "${COMPOSER_HOME}/cache"

WORKDIR /app

COPY ./app/composer.* /app
COPY ./app/symfony.lock /app

# --mount=type=cache,target=$COMPOSER_CACHE_DIR \
RUN \
  set -xe; \
  composer install \
  --no-scripts \
  --no-interaction \
  --optimize-autoloader \
  --classmap-authoritative \
  --profile

#######################################################################
# Installation base container
#######################################################################

FROM php:8.0-rc-fpm-alpine AS base

# Default environment variables
ENV APP_ENV dev
ENV APP_DEBUG 0
ENV APP_SECRET default-secret

ENV COMPOSER_HOME "/composer"
ENV COMPOSER_CACHE_DIR "${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT -1
ENV COMPOSER_ALLOW_SUPERUSER 1

ENV TZ "Europe/Moscow"
ENV PATH "/app/bin:/app/vendor/bin:${COMPOSER_HOME}/vendor/bin:$PATH"

#######################################################################
# Install PHP extensions
#######################################################################

# https://git.alpinelinux.org/aports/tree/community/php7/APKBUILD
# https://pecl.php.net/package/apcu

#  --mount=type=cache,target=/var/cache/apk \
#  --mount=type=cache,target=/tmp/ \
#  ln -sf /var/cache/apk /etc/apk/cache \

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN \
  set -xe; \
  # Install software and utilities
  apk add --no-cache --update \
    bash \
    ca-certificates \
    tzdata \
  # Setting the timezone
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  # Install PHP extensions
  && install-php-extensions \
    pdo \
    pdo_pgsql \
    intl \
    opcache \
    apcu \
    redis \
    xdebug

#######################################################################
# Default configuration
#######################################################################

COPY ./docker/php/conf.d/* "${PHP_INI_DIR}/conf.d/"
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

# Use the default development configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Set the working directory.
WORKDIR /app

CMD php-fpm

EXPOSE 9000

#######################################################################
# Source container
#######################################################################

FROM base as src

COPY ./app/bin /app/bin
COPY ./app/config /app/config
COPY ./app/public /app/public
COPY ./app/src /app/src
COPY ./app/templates /app/templates
COPY ./app/.env /app/.env

COPY --from=vendor /app/vendor /app/vendor

RUN set -xe \
  && mkdir -p /app/var \
  && chmod -R 777 /app/var \
  && chown -R www-data:www-data /app/*

#######################################################################
# Development container
#######################################################################

FROM src as dev

#ENV APP_ENV dev
#ENV APP_DEBUG 1

COPY --from=vendor "$COMPOSER_HOME" "$COMPOSER_HOME"
COPY --from=vendor /usr/bin/composer /usr/bin/composer

#######################################################################
# Production container
#######################################################################

FROM src as prod

ENV APP_ENV prod
ENV APP_DEBUG 0
