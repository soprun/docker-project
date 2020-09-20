###
### Installation base container
###

FROM php:7.4-fpm-alpine

RUN set -e \
    && apk add --update --no-cache $PHPIZE_DEPS \
        bash \
        git \
        zip \
        unzip \
        curl \
        libzip-dev \
        postgresql-dev \
    && docker-php-ext-install \
        opcache \
        pdo \
        pdo_pgsql \
        pgsql \
        intl \
        zip \
    && pecl install redis-5.1.1 \
    && pecl install xdebug-2.8.1 \
    && docker-php-ext-enable \
        opcache \
        redis \
        xdebug \
    && docker-php-source delete \
    && rm -rf \
        /var/cache/apk/* \
        /var/lib/apt/lists/*

###
### Copy configuration files
###

# Use the default production configuration
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.override.ini
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

###
### Install extensions and utilities
###

ENV COMPOSER_HOME="/composer"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"
ENV PATH="${PATH}:${COMPOSER_HOME}/vendor/bin"

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

###
### Copy source files to workdir
###

WORKDIR /app
COPY . /app

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
        --optimize-autoloader \
        --classmap-authoritative \
        --ignore-platform-reqs \
        --ansi \
        --profile

###
### Entrypoint
###

COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint;
ENTRYPOINT ["docker-entrypoint"]

###
### Startup
###

EXPOSE 9000
CMD ["php-fpm", "--nodaemonize"]
