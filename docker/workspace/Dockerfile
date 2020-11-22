### Installation base container
ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-cli-alpine AS build

# workdir
ARG APP_CODE_PATH="/app"
ARG APP_ENV="dev"
ARG APP_DEBUG="1"

ENV APP_ENV=$APP_ENV
ENV APP_DEBUG=$APP_DEBUG

### Extensions and utilities
ENV COMPOSER_HOME="/composer"
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

# persistent dependencies
RUN apk add --no-cache \
    # in theory, docker-entrypoint.sh is POSIX-compliant, but priority is a working, consistent image
    bash

COPY ./.shared/scripts/ /tmp/scripts/
RUN chmod +x -R /tmp/scripts/

# php config
COPY ./.shared/config/php/conf.d/*  /usr/local/etc/php/conf.d/

# use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN set -ex; \
	mkdir -p "${APP_CODE_PATH}"; \
	chown -R www-data:www-data "${APP_CODE_PATH}"

# Set the working directory.
WORKDIR "${APP_CODE_PATH}"

### Copying source files to workdir
#COPY ./app /app

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY ./workspace/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

# Set shell user
USER www-data

ENTRYPOINT ["docker-entrypoint"]

# cleanup
#RUN /tmp/scripts/cleanup
