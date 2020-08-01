FROM php:7.4-fpm-alpine

ENV APP_ENV="${app_env:-dev}"
ENV APP_DEBUG="${app_debug:-false}"

RUN \
    apk add --update --no-cache $PHPIZE_DEPS \
        bash \
        git \
        zip \
        unzip \
    ; \
    docker-php-ext-install \
        opcache \
        mbstring \
        pdo \
        pdo_pgsql \
        pgsql \
        intl \
        zip \
        pcntl \
    ; \
    pecl install \
        amqp \
        apcu \
        memcached \
        redis \
        xdebug \
        yaml \
    ; \
    docker-php-ext-enable \
        opcache \
        amqp \
        apcu \
        memcached \
        redis \
        yaml \
    ; \
    rm -rf \
    /var/cache/apk/* \
    /var/lib/apt/lists/*

# Use the default production configuration
# RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY ./docker/php-fpm/php.ini "${PHP_INI_DIR}/conf.d/php.override.ini"
COPY ./docker/php-fpm/xdebug.ini "${PHP_INI_DIR}/conf.d/xdebug.ini"

# Only for php-fpm:
# COPY docker/php-fpm/docker/php/www.conf "/usr/local/etc/php-fpm.d/www.conf"


# https://getcomposer.org/doc/03-cli.md
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"
# ENV COMPOSER_NO_INTERACTION=1
# ENV COMPOSER_HOME="${HOME}/.composer"
# ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# COPY composer.* /app
# RUN composer install --no-dev --no-scripts --no-suggest --no-interaction --prefer-dist --optimize-autoloader

COPY . /app
RUN composer dump-autoload --no-dev --optimize --classmap-authoritative

COPY ./docker/php-fpm/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

CMD ["/usr/local/bin/init.sh", "php-fpm"]
