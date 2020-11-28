#######################################################################
# Installation base container
#######################################################################

ARG PHP_VERSION
ARG APP_ENV="dev"
ARG APP_DEBUG="1"
ARG APP_DIR="/app"

# add users
#ARG APP_USER=www-data
#ARG APP_USER_ID=1000
#ARG APP_GROUP=$(APP_USER)
#ARG APP_GROUP_ID=$(APP_USER_ID)

FROM php:${PHP_VERSION}-fpm-alpine AS build

#######################################################################
# Default environment variables
#######################################################################

ARG APP_ENV
ARG APP_DEBUG
ARG APP_DIR

ENV APP_ENV=$APP_ENV
ENV APP_DEBUG=$APP_DEBUG

ENV PATH="${APP_DIR}/bin:$PATH"
ENV PATH="${APP_DIR}/vendor/bin:$PATH"

ENV TZ=UTC
ENV LANG=en_US.UTF8
ENV LANGUAGE=en

#######################################################################
# Install PHP extensions
#######################################################################

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions \
  intl \
  opcache \
  apcu \
  redis

#######################################################################
# Default configuration
#######################################################################

COPY ./docker/php/conf.d/* "${PHP_INI_DIR}/conf.d/"
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

# Use the default development configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

#######################################################################
# Install extensions and utilities
#######################################################################

#RUN set -eux \
#  # Permission fix
#  # && usermod -u 1000 www-data \
#  # Install extensions and utilities
#  && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
#    postgresql-dev \
#  # Install required PHP extensions
#  && docker-php-ext-install \
#    pdo \
#    pdo_pgsql \
#    opcache \
#    intl \
#  # PECL extensions
#  && pecl install \
#    # apcu-5.1 \
#    redis-5.1 \
#    xdebug \
#  && docker-php-ext-enable \
#    # apcu \
#    # redis \
#    xdebug \
#    opcache \
#  # Remove unnecessary stuff
#  && docker-php-source delete \
#  && pecl clear-cache \
#  && apk del .build-deps

# Permission fix
#RUN addgroup -G 1000 www-data

RUN set -ex; \
	mkdir -p "$APP_DIR"; \
	chown -R www-data:www-data "$APP_DIR"

# Set the working directory.
WORKDIR "$APP_DIR"

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

# Copying source files to workdir
# COPY ./app /app

CMD php-fpm

EXPOSE 9000

#######################################################################
# Installation building a development image from build.
#######################################################################

FROM build AS dev

#######################################################################
# Install software and utilities
#######################################################################

# persistent dependencies
RUN set -eux \
  && apk add --no-cache \
    curl \
    bash \
    git \
    vim \
    make \
    unzip

#######################################################################
# Install development PHP extensions
#######################################################################

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions \
  xdebug

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
# Installation building a production image from build.
#######################################################################

FROM build AS prod

ARG APP_ENV
ARG APP_DEBUG

ENV APP_ENV="${APP_ENV:-prod}"
ENV APP_DEBUG="${APP_DEBUG:-0}"

### Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

