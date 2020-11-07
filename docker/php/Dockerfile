
# Tags:
# 7.3-fpm-stretch
# 7.3-cli-stretch
# cli-alpine
# fpm-alpine

FROM composer:latest as composer

ENV COMPOSER_HOME="/composer"
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"

WORKDIR /app

COPY ./app/composer.* /app
COPY ./app/symfony.lock /app

RUN set -eux; \
    # Install composer plugin
    composer global require hirak/prestissimo \
       --no-progress \
       --no-scripts \
       --no-interaction \
       --ignore-platform-reqs \
    ; \
    # Install application dependencies
    composer install \
      --no-dev \
      --no-progress \
      --no-scripts \
      --no-interaction \
      --prefer-dist \
      --optimize-autoloader \
      --classmap-authoritative \
      --profile

# Installation base container
FROM php:7.4-fpm-alpine AS build

### Environment variables
ENV TZ=UTC
ENV LANG=en_US.UTF8
ENV LANGUAGE=en

# Set the working directory.
WORKDIR /app

# Copy source files to workdir
COPY ./app /app
COPY --from=soprun/sandbox-main-php-fpm:composer /app/vendor /app/vendor

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 9000

COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

# Run the specified command within the container.
CMD ["php-fpm", "--nodaemonize"]
