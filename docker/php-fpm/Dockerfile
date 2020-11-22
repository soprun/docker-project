ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-fpm-alpine AS build

COPY ./.shared/scripts/ /tmp/scripts/
RUN chmod +x -R /tmp/scripts/

# set timezone
#ARG TZ="UTC"
#RUN /tmp/scripts/set_timezone "${TZ}"

# php config
COPY ./.shared/config/php/conf.d/*  /usr/local/etc/php/conf.d/

# Make sure the volumes have the correct ownership
#ARG APP_CACHE_PATH
#RUN mkdir -p "${APP_CACHE_PATH}" && chown ${APP_USER}: "${APP_CACHE_PATH}"
#ARG APP_LOG_PATH
#RUN mkdir -p "${APP_LOG_PATH}" && chown ${APP_USER}: "${APP_LOG_PATH}"

# workdir
ARG APP_CODE_PATH="/app"
WORKDIR "$APP_CODE_PATH"

# cleanup
RUN /tmp/scripts/cleanup

ENTRYPOINT ["php-fpm"]
EXPOSE 9000
