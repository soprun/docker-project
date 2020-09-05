###
### Installation container
###

FROM php:${PHP_CLI_VERSION:-7.4}-cli-alpine AS build

###
### Environment variables
###

ENV \
    TZ=UTC \
    LANG=en_US.UTF8 \
    LANGUAGE=en

###
### Install
###

RUN set -eu; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
        bash \
        gnupg \
        openssl \
        openssh-client \
        curl \
        vim \
        git \
    ; \
    apk del .build-deps

###
### Copy configuration files
###

COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.ini
COPY ./docker/php/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

###
### Install composer
###

#ENV COMPOSER_MEMORY_LIMIT="-1"
#ENV COMPOSER_ALLOW_SUPERUSER="1"
#ENV PATH="${PATH}:/root/.composer/vendor/bin"

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

###
### Change working directory
###

WORKDIR /app

###
### Copy source files to workdir
###

COPY . /app

###
### Install dependencies
###

RUN set -eu \
    chmod +x /usr/local/bin/docker-entrypoint; \
    composer install \
        --ignore-platform-reqs \
        --no-scripts \
        --optimize-autoloader \
        --classmap-authoritative \
        --profile;
