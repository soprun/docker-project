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

# ENV EXT_IGBINARY_VERSION=3.0.1
ENV PHP_EXT_REDIS_VERSION=5.1.1
ENV PHP_EXT_XDEBUG_VERSION=2.8.1
ENV PHP_EXT_MEMCACHED_VERSION=3.1.4

###
### Install OS-level dependencies
###

RUN set -eu; \
    apk --no-cache add git curl zip vim

# gnupg
# bash
# openssl
# openssh-client

###
### Install language-level dependencies
###

RUN set -eu; \
    apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
        libzip-dev \
        libmemcached-dev \
        postgresql-dev \
    && docker-php-source extract \
    && docker-php-ext-install \
        pdo \
        pdo_pgsql \
        opcache \
        intl \
        zip \
    # cleanup
    && docker-php-source delete

RUN set -eu; \
    pecl install redis-${PHP_EXT_REDIS_VERSION}; \
    docker-php-ext-enable redis

RUN set -eu; \
    pecl install xdebug-${PHP_EXT_XDEBUG_VERSION}; \
    docker-php-ext-enable xdebug

RUN set -eu; \
    pecl install memcached-${PHP_EXT_MEMCACHED_VERSION}; \
    docker-php-ext-enable memcached

###
### Copy configuration files
###

COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.ini
COPY ./docker/php/php-fpm.conf /usr/local/etc/php-fpm.conf

###
### Install extensions and utilities
###

### Install composer
ENV COMPOSER_HOME=/composer
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN \
    curl --location --output /usr/local/bin/composer https://getcomposer.org/composer-stable.phar; \
    chmod +x /usr/local/bin/composer

### Install phpunit
RUN \
    curl --location --output /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar; \
    chmod +x /usr/local/bin/phpunit

###
### Change working directory
###

WORKDIR /app

###
### Copy source files to workdir
###

COPY . /app

###
### Install application dependencies
###

RUN set -eu; \
    composer check-platform-reqs; \
    composer install \
        --ignore-platform-reqs \
        --no-scripts \
        --optimize-autoloader \
        --classmap-authoritative \
        --profile;
