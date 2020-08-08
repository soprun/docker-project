ARG APP_DIR
ARG APP_ENV
ARG APP_DEBUG

###
### Installation container
###

FROM php:7.2-cli-alpine AS build

###
### Environment variables
###

ENV APP_DIR="${APP_DIR:-/app}"
ENV APP_ENV="${APP_ENV:-dev}"
ENV APP_DEBUG="${APP_DEBUG:-1}"

###
### Install
###

RUN set -eux; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
        bash \
    ; \
    apk del .build-deps

###
### Installation building a development image from build.
###

FROM build AS dev

ENV APP_ENV="${APP_ENV:-dev}"
ENV APP_DEBUG="${APP_DEBUG:-1}"

###
### Installation building a production image from build.
###

FROM build AS prod

ENV APP_ENV="${APP_ENV:-prod}"
ENV APP_DEBUG="${APP_DEBUG:-0}"
