ARG PHP_VERSION=7.4

###
### Installation dependencies container
###

FROM composer:latest as composer

ENV COMPOSER_HOME="/composer"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

COPY ./app/composer.* /app/
COPY ./app/symfony.lock /app/

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

COPY ./app/ /app

RUN set -e \
    && composer dump-autoload \
        --optimize \
        --classmap-authoritative \
        --ansi \
        --profile

FROM php:${PHP_VERSION}-fpm-alpine AS builder

###
### Install extensions and utilities
###

ENV COMPOSER_HOME="/composer"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"
ENV PATH="${PATH}:${COMPOSER_HOME}/vendor/bin"

###
### Copy configuration files
###

# Use the default production configuration
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.override.ini
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

###
### Copy source files to workdir
###

WORKDIR /app
COPY ./app /app

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=composer /app/vendor /app/vendor
COPY --from=composer /composer /composer

###
### Docker healthcheck
###

COPY ./docker/php/docker-healthcheck.sh /usr/local/bin/docker-healthcheck
RUN chmod +x /usr/local/bin/docker-healthcheck
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["docker-healthcheck"]

###
### Docker entrypoint
###

COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

###
### Startup
###

EXPOSE 9000
CMD ["php-fpm"]

#curl=7.52.* \
#    ca-certificates=* \
#    git=1:2.11.* \
