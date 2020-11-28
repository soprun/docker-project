#######################################################################
# Installation base container
#######################################################################

FROM php:8.0-rc-fpm-alpine

#######################################################################
# Default environment variables
#######################################################################

ARG APP_ENV="dev"
ARG APP_DEBUG="1"
ARG APP_DIR="/app"

ENV APP_ENV=$APP_ENV
ENV APP_DEBUG=$APP_DEBUG

ENV PATH="${APP_DIR}/bin:$PATH"
# ENV PATH="${APP_DIR}/vendor/bin:$PATH"

#ENV TZ=UTC
#ENV LANG=en_US.UTF8
#ENV LANGUAGE=en

#######################################################################
# Install extensions and utilities
#######################################################################

# persistent dependencies
RUN set -eux \
  && apk add --no-cache \
    curl \
    bash \
    git \
    vim \
    make

RUN set -eux \
  # Permission fix
  # && usermod -u 1000 www-data \
  # Install extensions and utilities
  && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    postgresql-dev \
  # Install required PHP extensions
  && docker-php-ext-install \
    pdo \
    pdo_pgsql \
    opcache \
    intl \
  # PECL extensions
  && pecl install \
    # apcu-5.1 \
    redis-5.1 \
    xdebug \
  && docker-php-ext-enable \
    # apcu \
    # redis \
    xdebug \
    opcache \
  # Remove unnecessary stuff
  && docker-php-source delete \
  && pecl clear-cache \
  && apk del .build-deps

#######################################################################
# Install composer & composer plugins
#######################################################################

ENV COMPOSER_HOME="/composer"
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

ENV PATH="${COMPOSER_HOME}/vendor/bin:$PATH"

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install composer plugin
RUN composer global require hirak/prestissimo \
  --no-progress \
  --no-scripts \
  --no-interaction \
  --ignore-platform-reqs \
  --optimize-autoloader \
  --classmap-authoritative \
  --profile

#######################################################################
# Default configuration
#######################################################################

COPY ./docker/php/conf.d/* "${PHP_INI_DIR}/conf.d/"
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

# Use the default development configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Permission fix
#RUN addgroup -G 1000 www-data

RUN set -ex; \
	mkdir -p /app; \
	chown -R www-data:www-data /app

# Set the working directory.
WORKDIR /app

# Copying source files to workdir
#COPY ../app /app

#######################################################################
# Copying & install application dependencies
#######################################################################

#COPY ./app/composer.* /app
#COPY ./app/symfony.lock /app
#
#### Install application dependencies
#RUN composer install \
#  --no-dev \
#  --no-progress \
#  --no-scripts \
#  --no-interaction \
#  --prefer-dist \
#  --optimize-autoloader \
#  --classmap-authoritative \
#  --profile

CMD php-fpm

EXPOSE 9000
