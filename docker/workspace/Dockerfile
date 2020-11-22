### Installation base container
ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-cli-alpine AS builder

COPY ./.shared/scripts/ /tmp/scripts/
RUN chmod +x -R /tmp/scripts/

# set timezone
ARG TZ="UTC"
RUN /tmp/scripts/set_timezone "${TZ}"

# add users
ARG APP_USER=www-data
ARG APP_GROUP=www-data
ARG APP_USER_ID=1000
ARG APP_GROUP_ID=1000

# php config
COPY ./.shared/config/php/conf.d/*  /usr/local/etc/php/conf.d/

# workdir
ARG APP_CODE_PATH="/app"
WORKDIR "$APP_CODE_PATH"

RUN /tmp/scripts/cleanup
