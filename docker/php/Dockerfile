
###
### Installation base container
###

FROM php:7.4-fpm-alpine AS base

### Environment variables
ENV TZ=UTC
ENV LANG=en_US.UTF8
ENV LANGUAGE=en

# Set the working directory.
WORKDIR /app

### Copying configuration files
COPY ./docker/php/conf.d/ "$PHP_INI_DIR/conf.d/"
COPY ./docker/php/php.ini "$PHP_INI_DIR/conf.d/zz-php.ini"
COPY ./docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

### Copying source files to workdir
COPY ./app /app

### Copying application dependencies
COPY --from=soprun/sandbox-main-php:composer ./app/vendor /app/vendor

### Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 9000

COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

### Run the specified command within the container.
CMD ["php-fpm", "--nodaemonize"]
