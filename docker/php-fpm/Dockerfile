### Installation base container
ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-fpm-alpine AS build

COPY ./.shared/scripts/ /tmp/scripts/
RUN chmod +x -R /tmp/scripts/

# php config
COPY ./.shared/config/php/conf.d/*  /usr/local/etc/php/conf.d/

# workdir
ARG APP_CODE_PATH="/app"
WORKDIR "$APP_CODE_PATH"

# cleanup
RUN /tmp/scripts/cleanup

ENTRYPOINT ["php-fpm"]
EXPOSE 9000
