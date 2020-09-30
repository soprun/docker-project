# https://github.com/devilbox/docker-php-fpm-7.4

ARG APP_ENV="dev"
ARG APP_DEBUG="1"

ARG PHP_VERSION=7.4
ARG APCU_VERSION=5.1.18
ARG REDIS_VERSION=5.1.1
ARG XDEBUG_VERSION=2.8.1

### Installation base container
FROM php:${PHP_VERSION}-fpm-alpine AS builder

LABEL \
  maintainer="Vladislav Soprun <develop@soprun.com>" \
  org.label-schema.docker.dockerfile="docker/php/Dockerfile" \
  org.label-schema.namespace="docker-sendbox" \
  org.label-schema.workspace="docker-sendbox" \
  org.label-schema.service_name="php" \
  org.label-schema.env="dev" \
  org.label-schema.stage="builder" \
  org.label-schema.tier="backend" \
  org.label-schema.vcs-type="Git" \
  org.label-schema.url="https://soprun.com" \
  org.label-schema.vcs-url="https://github.com/soprun/docker-project.git"

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
RUN set -eux \
  && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    postgresql-dev \
  # Persistent dependencies
  && apk add --no-cache \
    bash \
    curl \
    vim \
    supervisor \
    locales \
  # Install required PHP extensions
  && docker-php-ext-install \
    pdo \
    pdo_pgsql \
    opcache \
    mbstring \
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

RUN locale-gen en_US.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8
RUN /usr/sbin/update-locale

# Set the working directory.
WORKDIR /app

### Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

### Copy configuration files
COPY ./docker/php/conf.d/ "$PHP_INI_DIR/conf.d/"
COPY ./docker/php/php.ini "$PHP_INI_DIR/conf.d/zz-php.ini"
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

LABEL \
  org.label-schema.stage="prod"

ENV APP_ENV="prod"
ENV APP_DEBUG="0"

### Installation building a development image from build.
FROM builder AS dev

LABEL \
  org.label-schema.stage="dev"
