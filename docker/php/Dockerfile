### Environment variables
ARG APP_ENV=dev
ARG APP_DEBUG=0

### Install extensions and utilities
ARG PHP_VERSION=7.4
# ARG APCU_VERSION=5.1.18
# ARG REDIS_VERSION=5.1.1
# ARG XDEBUG_VERSION=2.8.1

ARG COMPOSER_HOME="/composer"

FROM composer:latest as composer

ARG COMPOSER_HOME

### Environment variables
ENV COMPOSER_HOME="$COMPOSER_HOME"
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

WORKDIR /app
COPY ./app/composer.* /app
COPY ./app/symfony.lock /app

RUN set -eux; \
    ## Install composer plugin
    composer global require hirak/prestissimo \
        --no-progress \
        --no-scripts \
        --no-interaction \
    ; \
    ## Install application dependencies
    # composer install \
    #     --no-progress \
    #     --no-scripts \
    #     --no-interaction \
    #     --optimize-autoloader \
    #     --classmap-authoritative \
    #     --profile

### Installation base container
FROM php:${PHP_VERSION}-fpm-alpine AS builder

ARG APP_ENV
ARG APP_DEBUG

### Environment variables
ENV TZ=UTC
ENV LANG=en_US.UTF8
ENV LANGUAGE=en
ENV PATH="${PATH}:/app/bin"

ENV APP_ENV="$APP_ENV"
ENV APP_DEBUG="$APP_DEBUG"

### Copy configuration files
COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.override.ini
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

### Copy source files to workdir
WORKDIR /app
COPY ./app /app

RUN set -eux; \
  chmod +x /usr/local/bin/docker-entrypoint;

### Startup
ENTRYPOINT ["docker-entrypoint"]
EXPOSE 9000
CMD ["php-fpm", "--nodaemonize"]

###
### Installation building a production image from build.
###

FROM builder AS prod

###
### Installation building a development image from build.
###

FROM builder AS dev

ARG COMPOSER_HOME

### Environment variables
ENV COMPOSER_HOME="$COMPOSER_HOME"
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

ENV PATH="${PATH}:${COMPOSER_HOME}/vendor/bin"

RUN set -eux; \
  # Persistent / Runtime deps
  apk add --no-cache \
    curl \
    bash \
    bash-completion \
    vim \
    git \
    make \
    gnupg \
    ca-certificates \
  ; \

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=composer "$COMPOSER_HOME" "$COMPOSER_HOME"

RUN set -eux; \
  chmod +x /usr/local/bin/docker-entrypoint; \

###
### Installation building a production image from build.
###

#FROM build AS production
#ENV APP_ENV="prod"
#ENV APP_DEBUG="${APP_DEBUG:-0}"
