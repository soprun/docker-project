ARG PHP_VERSION=7.4

FROM composer:latest as composer

ENV COMPOSER_HOME="/composer"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

WORKDIR /app
COPY ./app/composer.* /app/
COPY ./app/symfony.lock /app/

RUN set -e \
    ## Install composer plugin
    && composer global require hirak/prestissimo \
        --no-progress \
        --no-scripts \
        --no-interaction \
    ## Install application dependencies
    && composer install \
        --no-progress \
        --no-scripts \
        --no-interaction \
        --optimize-autoloader \
        --classmap-authoritative \
        --profile

###
### Installation base container
###

FROM php:${PHP_VERSION}-fpm-alpine AS builder

ENV COMPOSER_HOME="/composer"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"
ENV PATH="${PATH}:${COMPOSER_HOME}/vendor/bin"

###
### Copy configuration files
###

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
