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

ENV APP_ENV="$APP_ENV"
ENV APP_DEBUG="$APP_DEBUG"

### Installation building a production image from build.
FROM builder AS prod

ENV APP_ENV="prod"
ENV APP_DEBUG="0"

### Installation building a development image from build.
FROM builder AS dev

ARG COMPOSER_HOME

### Environment variables
ENV COMPOSER_HOME="$COMPOSER_HOME"
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"
