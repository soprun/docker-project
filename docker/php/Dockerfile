ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-fpm-alpine AS builder

WORKDIR /app
COPY ./app /app

###
### Docker healthcheck
###

COPY ./docker/php/docker-healthcheck.sh /usr/local/bin/docker-healthcheck
RUN chmod +x /usr/local/bin/docker-healthcheck
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["docker-healthcheck"]

###
### Docker entrypoint
###

COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

###
### Startup
###

EXPOSE 9000
CMD ["php-fpm"]

#curl=7.52.* \
#    ca-certificates=* \
#    git=1:2.11.* \
