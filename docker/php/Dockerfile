ARG APP_ENV
ARG APP_DEBUG

###
### Installation container
###
FROM php:7.2-fpm-alpine AS builder

###
### Environment variables
###
ENV APP_ENV="${APP_ENV:-dev}" \
    APP_DEBUG="${APP_DEBUG:-1}" \
    COMPOSER_MEMORY_LIMIT="-1" \
    COMPOSER_ALLOW_SUPERUSER="1"

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
### Install composer
###

ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

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
COPY ./docker/php/php.ini "${PHP_INI_DIR}/conf.d/php.ini"
COPY ./docker/php/php-fpm.conf "/usr/local/etc/php-fpm.conf"
COPY ./docker/php/docker-entrypoint.sh "/usr/local/bin/docker-entrypoint.sh"

WORKDIR "${APP_PROJECT_PATH}"

# COPY composer.* /app
# RUN composer install --no-dev --no-scripts --no-suggest --no-interaction --prefer-dist --optimize-autoloader

COPY . .

RUN set -eux; \
    # chmod +x /usr/local/bin/init.sh; \
    chmod +x /usr/local/bin/docker-entrypoint.sh; \
    composer dump-autoload --no-dev --optimize --classmap-authoritative;

###
### Ports
###
EXPOSE 9000

###
### Start up
###
CMD ["php-fpm", "--nodaemonize"]

###
### Entrypoint
###
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
