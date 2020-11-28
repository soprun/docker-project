FROM php:8.0-rc-fpm-alpine

# workdir
ARG APP_ENV="dev"
ARG APP_DEBUG="1"

### Environment variables
ENV TZ=UTC
ENV LANG=en_US.UTF8
ENV LANGUAGE=en

ENV APP_ENV=$APP_ENV
ENV APP_DEBUG=$APP_DEBUG

ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

ENV PATH="/root/.symfony/bin:$PATH"
ENV PATH="/root/.composer/vendor/bin:$PATH"
ENV PATH="/app/bin:$PATH"
ENV PATH="/app/vendor/bin:$PATH"

RUN set -eux \
    # persistent dependencies
    && apk add --no-cache \
        bash \
        git \
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
        apcu-5.1 \
        redis-5.1 \
        xdebug-2.8.1 \
    && docker-php-ext-enable \
        apcu \
        redis \
        xdebug \
        opcache \
    # Remove unnecessary stuff
    && docker-php-source delete \
    && pecl clear-cache \
    && apk del .build-deps

# Use the default development configuration
RUN set -ex; \
    mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# php config
COPY ./php/conf.d/*  "${PHP_INI_DIR}/conf.d/"

# php-fpm pool config
COPY ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

# Permission fix
RUN usermod -u 1000 www-data

## install Symfony CLI
#RUN set -ex; \
#    curl -sS https://get.symfony.com/cli/installer | bash; \
#    mv /root/.symfony/bin/symfony /usr/local/bin/symfony

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

### Install composer plugin
RUN set -ex; \
    composer global require hirak/prestissimo \
        --no-progress \
        --no-scripts \
        --no-interaction \
        --ignore-platform-reqs \
        --optimize-autoloader \
        --classmap-authoritative \
        --profile

#RUN set -ex; \
#	mkdir -p /app; \
#	chown -R www-data:www-data /app

# Set the working directory.
WORKDIR /app

### Copying source files to workdir
#COPY ./app "${APP_CODE_PATH}"

#VOLUME /app

EXPOSE 9000

CMD php-fpm

# Copy the rest of your app's source code from your host to your image filesystem.
# COPY . .

#USER www-data
