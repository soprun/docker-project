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
    apk --no-cache add git curl zip

###
### Install language-level dependencies
###

RUN set -eu; \
    apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
        libzip-dev \
        libmemcached-dev \
        postgresql-dev

RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    opcache \
    intl \
    curl \
    zip

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

# COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

### Install composer
RUN curl --location --output /usr/local/bin/composer https://getcomposer.org/composer-stable.phar
RUN chmod +x /usr/local/bin/composer

### Install phpunit
RUN curl --location --output /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar
RUN chmod +x /usr/local/bin/phpunit

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
