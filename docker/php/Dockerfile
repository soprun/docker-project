ARG APP_DIR
ARG APP_ENV
ARG APP_DEBUG

###
### Installation container
###

FROM php:7.2-fpm-alpine AS builder

###
### Environment variables
###

ENV APP_DIR="${APP_DIR:-/var/app}"
ENV APP_ENV="${APP_ENV:-dev}"
ENV APP_DEBUG="${APP_DEBUG:-1}"

###
### Context environment
###

# ENV PATH="${PATH}:${HOME}/.composer/vendor/bin"
ENV PATH="${PATH}:${APP_DIR}/bin"
ENV PATH="${PATH}:${APP_DIR}/vendor/bin"

###
### Labels
### https://github.com/opencontainers/image-spec/blob/master/annotations.md
###

LABEL "maintainer"="Vladislav Soprun <develop@soprun.com>"
LABEL "dev.sandbox.image.vendor"="soprun"
LABEL "dev.sandbox.image.source"="https://github.com/soprun/docker-project"
LABEL "dev.sandbox.image.documentation"="https://github.com/soprun/docker-project/wiki"
LABEL "dev.sandbox.image.title"="PHP-FPM"
LABEL "dev.sandbox.image.description"="Docker project: PHP-FPM"

LABEL "dev.sandbox.image.env"="${APP_ENV}"
LABEL "dev.sandbox.image.debug"="${APP_DEBUG}"
LABEL "dev.sandbox.image.release"="${APP_RELEASE}"
LABEL "dev.sandbox.image.commit_sha"="${APP_COMMIT_SHA}"

# install php-extension-installer

COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/bin/

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

WORKDIR "${APP_DIR}"

COPY . "${APP_DIR}"
# COPY ./bin/ "${APP_DIR}"
# COPY ./config/ "${APP_DIR}"
# COPY ./public/ "${APP_DIR}"
# COPY ./src/ "${APP_DIR}"
# COPY ./vendor/ "${APP_DIR}"
# COPY composer.* "${APP_DIR}"
# COPY symfony.lock "${APP_DIR}"

RUN set -eux; \
    # chmod +x /usr/local/bin/init.sh; \
    chmod +x /usr/local/bin/docker-entrypoint.sh; \
    # composer dump-autoload --optimize --classmap-authoritative; \
    composer install \
        --ignore-platform-reqs \
        --no-suggest \
        --no-interaction \
        --prefer-dist \
        --optimize-autoloader \
        --classmap-authoritative;

###
### Ports
###

EXPOSE 9000

###
### Startup
###

CMD ["php-fpm", "--nodaemonize"]

###
### Entrypoint
###

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
