ARG APP_ENV=dev
ARG APP_DEBUG=1
ARG COMPOSER_HOME="/composer"

### Installation base container
FROM php:7.4-fpm-alpine AS builder

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

### Installation composer container
FROM composer:latest AS composer

ARG COMPOSER_HOME

### Environment variables
ENV COMPOSER_HOME="$COMPOSER_HOME"
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
# ENV COMPOSER_MEMORY_LIMIT="-1"
# ENV COMPOSER_ALLOW_SUPERUSER="1"

# WORKDIR /app
# COPY ./app/composer.* /app
# COPY ./app/symfony.lock /app

RUN set -e; \
    ## Install composer plugin
    composer global require hirak/prestissimo \
        --no-progress \
        --no-scripts \
        --no-interaction \
        --profile

### Installation building a production image from build.
FROM builder AS prod

ENV APP_ENV="prod"
ENV APP_DEBUG="0"

### Installation building a development image from build.
FROM builder AS dev

ARG COMPOSER_HOME

### Environment variables
ENV COMPOSER_HOME="$COMPOSER_HOME"
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

ENV PATH="${PATH}:${COMPOSER_HOME}/vendor/bin"

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=composer "$COMPOSER_HOME" "$COMPOSER_HOME"
