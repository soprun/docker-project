###
### Installation container
###

FROM php:${PHP_VERSION:-7.4}-fpm-alpine

###
### Environment variables
###

ENV TZ=UTC
ENV LANG=en_US.UTF8
ENV LANGUAGE=en

ENV COMPOSER_HOME=/composer
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_ALLOW_SUPERUSER=1

ENV PATH="${PATH}:/app/bin"
ENV PATH="${PATH}:/composer/vendor/bin"

###
### Labels
### https://github.com/opencontainers/image-spec/blob/master/annotations.md
###

LABEL \
    com.app.env="${APP_ENV}" \
    com.app.debug="${APP_DEBUG}"
#    com.app.git_tag="${GIT_TAG}" \
#    com.app.git_branch="${GIT_BRANCH}" \
#    com.app.git_commit_id="${GIT_COMMIT_ID}" \
#    com.app.git_commit_sha="${GIT_COMMIT_SHA}" \
#    com.app.project_name="${PROJECT_NAME}" \
#    com.app.tier="backend" \
#    com.app.name="php" \
#    com.app.host="${APP_HOST}" \
#    com.app.title="..." \
#    com.app.description="..." \
#    com.app.vendor="inspiritum.com" \
#    com.app.authors="Vladislav Soprun <develop@soprun.com>" \
#    com.app.source="https://github.com/soprun/docker-project" \
#    com.app.documentation="https://github.com/soprun/docker-project/wiki"

###
### Copy configuration files
###

# Use the default production configuration
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# /usr/local/etc/php/php.ini
COPY ./docker/php/php.ini "$PHP_INI_DIR/php.ini"
COPY ./docker/php/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

###
### Install OS-level dependencies - persistent / runtime deps
### Install language-level dependencies
###

ARG PHP_EXTENSION_APCU_VERSION=5.1.17
ARG PHP_EXTENSION_REDIS_VERSION=5.1.1
ARG PHP_EXTENSION_XDEBUG_VERSION=2.8.1
ARG PHP_EXTENSION_MEMCACHED_VERSION=3.1.4

RUN set -eu; \
	apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
        libzip-dev \
        libmemcached-dev \
        postgresql-dev \
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
        make \
    && docker-php-ext-install \
        pdo \
        pdo_pgsql \
        pgsql \
        opcache \
        intl \
        zip \
    && pecl install redis-5.1.1 \
    && pecl install memcached-3.1.4 \
    && pecl install xdebug-2.8.1 \
    && docker-php-ext-enable \
        redis \
        memcached \
        xdebug \
    && docker-php-source delete \
    && RUN rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \
    && apk del .build-deps

###
### Change working directory
###

WORKDIR /app

###
### Copy source files to workdir
###

COPY . /app

###
### Install extensions and utilities
###

RUN \
    chmod +x /usr/local/bin/docker-entrypoint; \
    ## Install composer
    curl --location --output /usr/local/bin/composer https://getcomposer.org/composer-stable.phar; \
    chmod +x /usr/local/bin/composer; \
    ## Install phpunit
    curl --location --output /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar; \
    chmod +x /usr/local/bin/phpunit; \
    ## composer check-platform-reqs
    composer check-platform-reqs; \
    ## Install composer plugin
    composer global require hirak/prestissimo; \
    ## Compiles .env files to .env.local.php.
    composer symfony:dump-env dev; \
    ## Install application dependencies
    composer install \
        --no-scripts \
        --optimize-autoloader \
        --classmap-authoritative \
        --profile; \
###
### Mount
###

VOLUME ["/app"]

###
### Entrypoint
###

ENTRYPOINT ["docker-entrypoint"]

###
### Startup
###

CMD ["php-fpm", "--nodaemonize"]
