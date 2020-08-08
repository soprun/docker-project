ARG APP_DIR
ARG APP_ENV
ARG APP_DEBUG

###
### Installation container
###

FROM php:${PHP_CLI_VERSION}-alpine AS build

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
        make \
        bash \
        gnupg \
        openssl \
        curl \
        ca-certificates \
        vim \
    ; \
    install-php-extensions xdebug memcached opcache pdo_pgsql redis intl apcu; \
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
### Change working directory
###

WORKDIR "${APP_DIR}"

###
### Copy source files to workdir
###

COPY . "${APP_DIR}"

###
### Entrypoint
###

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# FROM build AS development
# FROM build AS production