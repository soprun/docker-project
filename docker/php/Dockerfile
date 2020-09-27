### Installation base container
FROM php:7.4-fpm-alpine

RUN set -eux; \
  # Persistent / Runtime deps
  apk add --no-cache \
    bash \
    git \
  ; \
  # Install extensions and utilities
	apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    icu-dev \
    libzip-dev \
    zlib-dev \
    postgresql-dev \
	; \
	docker-php-ext-configure zip; \
  docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_pgsql \
    pgsql \
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
  apk del .build-deps

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

### Copy configuration files
COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.override.ini
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

### Environment variables
ENV COMPOSER_HOME="/composer"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

ENV PATH="${PATH}:${COMPOSER_HOME}/vendor/bin"

### Copy source files to workdir
WORKDIR /app
COPY ./app /app

RUN set -eux; \
  chmod +x /usr/local/bin/docker-entrypoint;

### Startup
ENTRYPOINT ["docker-entrypoint"]
EXPOSE 9000
CMD ["php-fpm"]
