### Installation base container
FROM php:7.4-fpm-alpine

RUN set -eux; \
  # Persistent / Runtime deps
  apk add --no-cache \
    bash \
    vim \
    git \
  ; \
  # Install extensions and utilities
	apk add --no-cache --update --virtual .build-deps \
    $PHPIZE_DEPS \
    icu-dev \
    libzip-dev \
    zlib-dev \
    postgresql-dev \
	; \
  docker-php-ext-install \
    pdo \
    pdo_pgsql \
    intl \
    zip \
  ; \
  pecl install \
    apcu-5.1.18 \
    redis-5.1.1 \
    xdebug-2.8.1 \
  ; \
  pecl clear-cache; \
  docker-php-ext-enable \
    apcu \
    redis \
    xdebug \
    opcache \
  ; \
  docker-php-source delete; \
  apk del .build-deps

### Environment variables
ENV COMPOSER_HOME="/composer"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

ENV PATH="${PATH}:${COMPOSER_HOME}/vendor/bin"

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

### Copy configuration files
COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.override.ini
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

### Copy source files to workdir
WORKDIR /app
COPY ./app /app

RUN set -eux; \
  chmod +x /usr/local/bin/docker-entrypoint; \
  ## Install composer plugin
  composer global require hirak/prestissimo --no-progress --no-scripts --no-interaction;

### Startup
ENTRYPOINT ["docker-entrypoint"]
EXPOSE 9000
CMD ["php-fpm"]
