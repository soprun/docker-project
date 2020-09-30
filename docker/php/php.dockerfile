ARG APP_ENV=dev
ARG APP_DEBUG=1
ARG COMPOSER_HOME="/composer"

### Installation base container
FROM php:7.4-fpm-alpine AS builder

ARG APP_ENV
ARG APP_DEBUG

### Environment variables
ENV TZ=UTC
ENV LANG=en_US.UTF8
ENV LANGUAGE=en
ENV PATH="${PATH}:/app/bin"

ENV APP_ENV="$APP_ENV"
ENV APP_DEBUG="$APP_DEBUG"

### Copy configuration files
COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.override.ini
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

### Copy source files to workdir
WORKDIR /app
COPY ./app /app

RUN set -eux; \
  chmod +x /usr/local/bin/docker-entrypoint;

### Startup
ENTRYPOINT ["docker-entrypoint"]
EXPOSE 9000
CMD ["php-fpm", "--nodaemonize"]
