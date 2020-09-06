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
### Install OS-level dependencies - persistent / runtime deps
###

RUN apk add --no-cache \
    openssl \
    openssh-client \
    ca-certificates \
    git \
    curl \
    zip \
    vim \
    gnupg \
    bash \
    make \
    autoconf \
    make

###
### Install language-level dependencies
###

RUN set -e; \
	apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
        libzip-dev \
        libmemcached-dev \
        postgresql-dev \
    && docker-php-ext-install \
        pdo \
        pdo_pgsql \
        pgsql \
        opcache \
        intl \
        zip \
    && docker-php-source delete

# ARG PHP_EXTENSION_APCU_VERSION=5.1.17
ARG PHP_EXTENSION_REDIS_VERSION=5.1.1
ARG PHP_EXTENSION_XDEBUG_VERSION=2.8.1
ARG PHP_EXTENSION_MEMCACHED_VERSION=3.1.4

RUN pecl install redis-${PHP_EXTENSION_REDIS_VERSION} \
    && docker-php-ext-enable redis

RUN pecl install xdebug-${PHP_EXTENSION_XDEBUG_VERSION} \
    && docker-php-ext-enable xdebug

RUN pecl install memcached-${PHP_EXTENSION_MEMCACHED_VERSION} \
    && docker-php-ext-enable memcached

###
### Copy configuration files
###

COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.ini
COPY ./docker/php/php-fpm.conf /usr/local/etc/php-fpm.conf

###
### Install extensions and utilities
###

RUN \
    ### Install composer
    curl --location --output /usr/local/bin/composer https://getcomposer.org/composer-stable.phar; \
    chmod +x /usr/local/bin/composer; \
    ### Install phpunit
    curl --location --output /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar; \
    chmod +x /usr/local/bin/phpunit;

###
### Change working directory
###

WORKDIR ${PROJECT_DIR}

###
### Copy source files to workdir
###

COPY . ${PROJECT_DIR}

###
### Install application dependencies
###

#RUN set -eu; \
#    composer check-platform-reqs; \
#    composer install \
#        --ignore-platform-reqs \
#        --no-scripts \
#        --optimize-autoloader \
#        --classmap-authoritative \
#        --profile;

###
### Mount
###

VOLUME ["/app"]

###
### Startup
###

CMD ["php", "-a"]
