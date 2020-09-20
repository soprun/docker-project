###
### Installation dependencies container
###

FROM composer:latest as composer

ENV COMPOSER_HOME="/composer"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

COPY ./composer.* /app/
COPY ./symfony.lock /app/

RUN set -e \
    ## Install composer plugin
    && composer global require hirak/prestissimo \
        --no-progress \
        --no-scripts \
        --no-interaction \
        --ignore-platform-reqs \
        --ansi \
    ## Install application dependencies
    && composer install \
        --no-progress \
        --no-scripts \
        --no-interaction \
        --no-autoloader \
        --ignore-platform-reqs \
        --ansi \
        --profile

COPY . /app

RUN set -e \
    && composer dump-autoload \
        --optimize \
        --classmap-authoritative \
        --ansi \
        --profile

###
### Installation base container
###

FROM php:7.4-fpm-alpine AS build

RUN apk update \
    && apk add --no-cache $PHPIZE_DEPS \
        libzip-dev \
        postgresql-dev \
    && docker-php-ext-install \
        opcache \
        pdo \
        pdo_pgsql \
        pgsql \
        intl \
        zip \
    && pecl install redis-5.1.1 \
    && pecl install xdebug-2.8.1 \
    && docker-php-ext-enable \
        opcache \
        redis \
        xdebug \
    && docker-php-source delete \
    && rm -rf \
        /var/cache/apk/* \
        /var/lib/apt/lists/*

###
### Copy configuration files
###

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.override.ini
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

###
### Copy source files to workdir
###

WORKDIR /app
COPY . /app
COPY --from=composer /app/vendor /app/vendor

###
### Entrypoint
###

COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint;
ENTRYPOINT ["docker-entrypoint"]

###
### Startup
###

EXPOSE 9000
CMD ["php-fpm", "--nodaemonize"]

###
### Installation building a development image from build.
###

FROM build AS dev

ENV COMPOSER_HOME="/composer"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

ENV PATH="${PATH}:/app/bin"
ENV PATH="${PATH}:${COMPOSER_HOME}/vendor/bin"

## Install dependencies
RUN apk update \
 && apk add --no-cache \
    bash \
    git \
    zip \
    unzip

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=composer /composer /composer

###
### Installation building a production image from build.
###

FROM build AS prod

ENV APP_ENV="prod"
ENV APP_DEBUG="${APP_DEBUG:-0}"
