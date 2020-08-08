ARG APP_DIR
ARG APP_ENV
ARG APP_DEBUG

###
### Installation container
###

FROM php:${PHP_CLI_VERSION:-7.2}-cli-alpine AS build

###
### Environment variables
###

ENV APP_DIR="${APP_DIR:-/var/app}"
ENV APP_ENV="${APP_ENV:-dev}"
ENV APP_DEBUG="${APP_DEBUG:-1}"

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

###
### Context environment
###

ENV PATH="${PATH}:${APP_DIR}/bin"
ENV PATH="${PATH}:${APP_DIR}/vendor/bin"

###
### Labels
### https://github.com/opencontainers/image-spec/blob/master/annotations.md
###

###
### Install
###

RUN set -eux; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
        git \
        bash \
        make \
        gnupg \
        openssl \
        curl \
        ca-certificates \
        vim \
    ; \
    apk del .build-deps

###
### Install and enable PHP modules
###

###
### Copy files
###

COPY ./docker/php/php.ini "/usr/local/etc/php/conf.d/php.ini,"
COPY ./docker/php/php-fpm.conf "/usr/local/etc/php-fpm.conf"
COPY ./docker/php/docker-entrypoint.sh "/usr/local/bin/docker-entrypoint.sh"

###
### Change working directory
###

WORKDIR "${APP_DIR}"

###
### Copy source files to workdir
###

COPY . "${APP_DIR}"

###
### Install composer
###

ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN set -eux; \
    chmod +x /usr/local/bin/docker-entrypoint.sh; \
    ### PHP Composer
    composer global require hirak/prestissimo --ignore-platform-reqs; \
    composer install \
        --ignore-platform-reqs \
        --no-suggest \
        --no-interaction \
        --prefer-dist \
        --optimize-autoloader \
        --classmap-authoritative;

###
### Entrypoint
###

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

###
### Installation building a development image from build.
###

FROM build AS dev

###
### Install
###

RUN set -eux; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
        git \
        bash \
        make \
        gnupg \
        openssl \
        curl \
        ca-certificates \
        vim \
    ; \
    apk del .build-deps;

###
### Installation building a production image from build.
###

FROM build AS prod

