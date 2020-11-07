
# Tags:
# 7.3-fpm-stretch
# 7.3-cli-stretch
# cli-alpine
# fpm-alpine

ARG APP_ENV=dev
ARG APP_DEBUG=1

ARG PHP_VERSION=7.4

### Installation base container
FROM php:${PHP_VERSION}-fpm-alpine AS build

ARG APP_ENV
ARG APP_DEBUG

### Environment variables
ENV TZ=UTC
ENV LANG=en_US.UTF8
ENV LANGUAGE=en

ENV APP_ENV=$APP_ENV
ENV APP_DEBUG=$APP_DEBUG

# Set the working directory.
WORKDIR /app

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 9000

#COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
#RUN chmod +x /usr/local/bin/docker-entrypoint
#ENTRYPOINT ["docker-entrypoint"]

# Run the specified command within the container.
# CMD ["php-fpm", "--nodaemonize"]
