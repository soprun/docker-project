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
RUN set -eux \
  # Persistent / Runtime dependencies
	&& apk add --no-cache \
    git \
    tree \
    vim \
    zip \
    curl \
    bash \
    bash-completion \
    make \
    gnupg \
    ca-certificates \
  ;

RUN set -eux \
  # Install extensions and utilities
	&& apk add --no-cache \
    $PHPIZE_DEPS \
    libssl-dev \
    libzip-dev \
    libpq-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libicu-dev \
	; \
	&& docker-php-ext-configure zip --with-libzip \
	&& docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

RUN set -eux \
  && docker-php-ext-install -j$(nproc) \
  && docker-php-ext-install pgsql \
  && docker-php-ext-install pdo \
  && docker-php-ext-install pdo_pgsql \
  && docker-php-ext-install intl \
  && docker-php-ext-install zip \
  && docker-php-ext-install exif \
  && docker-php-ext-install bcmath \
  && docker-php-ext-install opcache \
  && docker-php-ext-install gettext \
  && docker-php-ext-install pcntl \
  && docker-php-ext-install mbstring \
  && docker-php-source delete

RUN usermod -u 33 www-data

# Set the working directory.
WORKDIR /usr/src/app

### Copy configuration files
COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.override.ini
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Run the command inside your image filesystem.
# Install application dependencies
RUN set -eux; \
  composer install \
    --prefer-dist \
    --no-progress \
    --no-scripts \
    --no-interaction \
    --optimize-autoloader \
    --classmap-authoritative \
    --profile \
  ;\
  composer clear-cache

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 9000

# Run the specified command within the container.
CMD ["php-fpm", "--nodaemonize"]

# Copy the rest of your app's source code from your host to your image filesystem.
### Copy source files to workdir
COPY ./app /usr/src/app
RUN chown -R 1000:1000 /usr/src/app
