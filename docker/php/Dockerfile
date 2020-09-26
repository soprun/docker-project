FROM php:7.4-fpm-alpine AS builder

WORKDIR /app
COPY ./app /app

EXPOSE 9000
CMD ["php-fpm", "--nodaemonize"]


#curl=7.52.* \
#    ca-certificates=* \
#    git=1:2.11.* \
