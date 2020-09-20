###
### Installation dependencies container
###

FROM composer:2 as composer

COPY ./composer.* /app/
COPY ./symfony.lock /app/

RUN set -e; \
    composer install \
        --no-scripts \
        --no-interaction \
        --no-autoloader \
        --no-dev \
        --prefer-dist \
        --ignore-platform-reqs \
        --profile;

COPY . /app

RUN set -e; \
    composer dump-autoload \
    --no-dev \
    --optimize \
    --classmap-authoritative \
    --profile;

###
### Installation base container
###

FROM php:7.4-fpm-alpine AS builder

#ENV TZ="UTC"
#ENV LANG="en_US.UTF8"
#ENV LANGUAGE="en"

ENV COMPOSER_HOME="/composer"
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

# ENV PATH="${PATH}:/app/bin"
ENV PATH="${PATH}:${COMPOSER_HOME}/vendor/bin"

RUN set -e; \
    apk add --no-cache $PHPIZE_DEPS \
        postgresql-libs \
        icu-libs \
    && docker-php-ext-install \
        opcache \
        pdo \
        pdo_pgsql \
        mbstring \
        intl \
    && docker-php-ext-enable \
        opcache \
    && rm -rf \
        /var/cache/apk/* \
        /var/lib/apt/lists/*

###
### Copy configuration files
###

COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.override.ini
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

###
### Copy source files to workdir
###

WORKDIR /app
COPY . /app
COPY --from=composer /app/vendor /app/vendor

###
### Startup
###

EXPOSE 9000
CMD ["php-fpm", "--nodaemonize"]

###
### Installation building a development image from build.
###

FROM builder AS development

ENV APP_ENV="${APP_ENV:-dev}"
ENV APP_DEBUG="${APP_DEBUG:-1}"

# Install dependencies

RUN set -e; \
    apk add --no-cache $PHPIZE_DEPS \
        git \
    && docker-php-ext-install \
        xdebug \
    && docker-php-ext-enable \
        xdebug \
    && rm -rf \
        /var/cache/apk/* \
        /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN set -e; \
    ## Install composer plugin
    composer global require hirak/prestissimo \
        --prefer-dist \
        --prefer-stable \
        --no-progress \
        --no-scripts \
        --no-interaction \
        --ansi; \
    ## Install application dependencies
    composer install \
        --no-interaction \
        --no-scripts \
        --prefer-dist \
        --optimize-autoloader \
        --classmap-authoritative \
        --ignore-platform-reqs \
        --profile;

###
### Installation building a production image from build.
###

#FROM build AS production
#ENV APP_ENV="prod"
#ENV APP_DEBUG="${APP_DEBUG:-0}"
