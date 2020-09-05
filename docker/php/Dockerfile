###
### Installation container
###

FROM php:${PHP_VERSION:-7.4}-fpm-alpine AS build

ARG APP_ENV
ARG APP_DEBUG

###
### Environment variables
###

ENV \
    TZ=UTC \
    LANG=en_US.UTF8 \
    LANGUAGE=en \
    APP_DIR=${APP_DIR:-/app} \
    APP_ENV="${APP_ENV}" \
    APP_DEBUG="${APP_DEBUG}" \
    PATH="${PATH}:${APP_BIN_DIR}"

###
### Labels
### https://github.com/opencontainers/image-spec/blob/master/annotations.md
###

LABEL \
    com.app.env="${APP_ENV}" \
    com.app.debug="${APP_DEBUG}" \
    com.app.branch="${APP_BRANCH}" \
    com.app.commit_id="${APP_COMMIT_ID}" \
    com.app.commit_sha="${APP_COMMIT_SHA}" \
    com.app.namespace="${APP_NAMESPACE}" \
    com.app.name="php" \
    com.app.host="${APP_HOST}" \
    com.app.title="..." \
    com.app.description="..." \
    com.app.vendor="inspiritum.com" \
    com.app.authors="Vladislav Soprun <develop@soprun.com>" \
    com.app.source="https://github.com/soprun/docker-project" \
    com.app.documentation="https://github.com/soprun/docker-project/wiki"

###
### Install
###
RUN \
    set -eu; \
    apk --no-cache add bash

###
### Copy configuration files
###

# COPY ./docker/php/php.ini "/usr/local/etc/php/conf.d/php.ini,"
# COPY ./docker/php/php-fpm.conf "/usr/local/etc/php-fpm.conf"
COPY ./docker/php/docker-entrypoint.sh "/usr/local/bin/docker-entrypoint"

###
### Install composer
###

ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"
ENV PATH="${PATH}:/root/.composer/vendor/bin"

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

###
### Install composer
###

# RUN curl --location --output /usr/local/bin/composer https://getcomposer.org/composer-stable.phar
# RUN chmod +x /usr/local/bin/composer

###
### Install phpunit
###

# RUN curl --location --output /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar
# RUN chmod +x /usr/local/bin/phpunit

###
### Change working directory
###

WORKDIR "${APP_DIR}"

###
### Copy source files to workdir
###

COPY "${APP_DOCUMENT_ROOT}" "${APP_DIR}"

###
### Install dependencies
###

RUN set -eu; \
    chmod +x /usr/local/bin/docker-entrypoint; \
    composer install \
        --ignore-platform-reqs \
        --no-scripts \
        --optimize-autoloader \
        --classmap-authoritative

###
### Expose port
###

EXPOSE 9000

###
### Entrypoint
###

ENTRYPOINT ["docker-entrypoint"]

###
### Startup
###

CMD ["php-fpm", "--nodaemonize"]