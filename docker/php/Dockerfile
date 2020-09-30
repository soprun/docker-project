# https://github.com/devilbox/docker-php-fpm-7.4

ARG APP_ENV="dev"
ARG APP_DEBUG="1"

ARG PHP_VERSION=7.4
ARG APCU_VERSION=5.1.18
ARG REDIS_VERSION=5.1.1
ARG XDEBUG_VERSION=2.8.1

### Installation base container
FROM php:${PHP_VERSION}-fpm-alpine AS builder

ARG APP_ENV
ARG APP_DEBUG

ARG PHP_VERSION
ARG APCU_VERSION
ARG REDIS_VERSION
ARG XDEBUG_VERSION

### Environment variables
ENV APP_ENV=$APP_ENV
ENV APP_DEBUG=$APP_DEBUG

### Extensions and utilities
ENV COMPOSER_HOME="/composer"
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

### install dependencies
RUN apk update \
   # Install extensions and utilities
  && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    postgresql-dev \
  # Persistent dependencies
  && apk add --no-cache \
    bash \
  # Install required PHP extensions
  && docker-php-ext-install \
    pgsql \
    pdo \
    pdo_pgsql \
    opcache \
    mbstring \
    mcrypt \
    zip \
    intl \
  && docker-php-source delete \
  # PECL extensions
  && pecl install \
    apcu-$APCU_VERSION \
    redis-$REDIS_VERSION \
    xdebug-$XDEBUG_VERSION \
  && docker-php-ext-enable \
    apcu \
    redis \
    xdebug \
    opcache \
  # Remove unnecessary stuff
  && pecl clear-cache \
  && apk del .build-deps

# Set the working directory.
WORKDIR /app

### Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

### Copy configuration files
COPY ./docker/php/conf.d/ "$PHP_INI_DIR/conf.d/"
COPY ./docker/php/php.ini "$PHP_INI_DIR/conf.d/php.ini"
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Run the command inside your image filesystem.
# Install application dependencies
#RUN set -eux; \
#  composer install \
#    --prefer-dist \
#    --no-progress \
#    --no-scripts \
#    --no-interaction \
#    --optimize-autoloader \
#    --classmap-authoritative \
#    --profile \
#  ;\
#  composer clear-cache

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 9000

# Run the specified command within the container.
CMD ["php-fpm", "--nodaemonize"]

# Copy the rest of your app's source code from your host to your image filesystem.
### Copy source files to workdir
COPY ./app /app

RUN set -eux \
  && mkdir -p /app \
  && chown -R 1000:1000 /app

### Installation building a production image from build.
FROM builder AS prod

ENV APP_ENV="prod"
ENV APP_DEBUG="0"

### Installation building a development image from build.
FROM builder AS dev
