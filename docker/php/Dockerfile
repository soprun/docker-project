# syntax=docker/dockerfile:experimental
FROM composer:1.8 as vendor

ENV COMPOSER_HOME "/composer"
ENV COMPOSER_CACHE_DIR "${COMPOSER_HOME}/cache"

WORKDIR /app

COPY ./app/composer.* /app
COPY ./app/symfony.lock /app

RUN --mount=type=cache,target=$COMPOSER_CACHE_DIR \
  composer global require hirak/prestissimo \
  --ignore-platform-reqs \
  --no-scripts \
  --no-interaction \
  --optimize-autoloader \
  --classmap-authoritative \
  --profile

  # Install application dependencies
RUN --mount=type=cache,target=$COMPOSER_CACHE_DIR \
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

#######################################################################
# Default environment variables
#######################################################################

#ENV APP_ENV dev
#ENV APP_DEBUG 0
#ENV APP_SECRET default-secret

ENV PATH "${APP_DIR}/bin:$PATH"
ENV PATH "${APP_DIR}/vendor/bin:$PATH"

ENV TZ UTC
ENV LANG en_US.UTF8
ENV LANGUAGE en

#######################################################################
# Install composer & composer plugins
#######################################################################

ENV COMPOSER_HOME "/composer"
ENV COMPOSER_CACHE_DIR "${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT -1
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH "${COMPOSER_HOME}/vendor/bin:$PATH"

#######################################################################
# Install software and utilities
#######################################################################

# persistent dependencies
RUN --mount=type=cache,target=/var/cache/apk ln -sf /var/cache/apk /etc/apk/cache; \
  set -euo pipefail \
  && apk add --update \
    build-base \
    bash \
    unzip \
    curl \
    ca-certificates \
    openssl \
    tzdata

# && rm -rf /var/cache/apk/*

#######################################################################
# Setting the timezone
# https://wiki.alpinelinux.org/wiki/Setting_the_timezone
#######################################################################

ARG TZ="Europe/Moscow"
ENV TZ $TZ
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#######################################################################
# Install PHP extensions
#######################################################################

#COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
#RUN --mount=type=cache,target=/var/cache/apk \
#  install-php-extensions \
#  intl \
#  opcache \
#  apcu \
#  redis

RUN --mount=type=cache,target=/var/cache/apk ln -sf /var/cache/apk /etc/apk/cache \
  && set -xe \
  && apk add --virtual .build-deps $PHPIZE_DEPS \
  && apk add \
    postgresql-dev \
  && docker-php-source extract \
  && docker-php-ext-install \
    pdo \
    pdo_pgsql \
    intl \
    iconv \
    ctype \
    json \
    pcre \
    session \
    simplexml \
    tokenizer \
    opcache \
  # PECL extensions
  && pecl install \
    apcu-5.1.19 \
    redis-6.0.9 \
    xdebug-3.0.0 \
  && docker-php-ext-enable \
    opcache \
    apcu \
    redis \
    xdebug \
  # cleanup
  && docker-php-source delete \
  && apk del .build-deps \
  && rm -rf /tmp/* /var/cache/apk/*


# https://git.alpinelinux.org/aports/tree/community/php7/APKBUILD
# https://pecl.php.net/package/apcu

#RUN
#  set -euo pipefail \
#  && docker-php-source extract \
#  && apk add --virtual .build-deps $PHPIZE_DEPS \
#
#  ## Install PHP extensions
#  && docker-php-ext-install \
#
#  ## PECL extensions
#  && pecl install \
#    apcu \
#    redis \
#    xdebug \
#  && docker-php-ext-enable \
#    apcu \
#    redis \
#    xdebug \
#  ## cleanup
#  && docker-php-source delete \
#  && apk del .build-deps


#RUN \
#  --mount=type=cache,target=/tmp/* \
#  --mount=type=cache,target=/var/cache/* \
#  set -eux; \
#  ln -s /var/cache/apk /etc/apk/cache \
#  && apk update \
#  ## Install extensions and utilities
#  && apk add $PHPIZE_DEPS \
#    postgresql-dev \
#  && docker-php-source extract \
#  ## Install required PHP extensions
#  && docker-php-ext-install \
#    pdo \
#    pdo_pgsql \
#    opcache \
#    intl \
#  ## PECL extensions
#  && pecl install \
#    apcu \
#    redis \
#    xdebug \
#  && docker-php-ext-enable \
#    xdebug \
#    opcache \
#  ## cleanup
#  && docker-php-source delete


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

RUN mkdir -p /app/var ; \
  chmod -R 777 /app/var ; \
  chown -R www-data:www-data /app/*

#######################################################################
# Development container
#######################################################################

FROM src as dev

# ENV APP_ENV dev
# ENV APP_DEBUG 1

COPY --from=vendor "$COMPOSER_HOME" "$COMPOSER_HOME"
COPY --from=vendor /usr/bin/composer /usr/bin/composer

#######################################################################
# Production container
#######################################################################

FROM src as prod

# ENV APP_ENV prod
# ENV APP_DEBUG 0
