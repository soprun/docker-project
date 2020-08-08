ARG APP_ENV
ARG APP_DEBUG
ARG APP_RELEASE
ARG APP_SECRET

# installation container
FROM php:7.2-fpm-alpine AS builder

# environment variables
ENV APP_ENV="${APP_ENV:-dev}" \
    APP_DEBUG="${APP_DEBUG:-1}" \
    APP_SECRET="${APP_SECRET}" \
    APP_RELEASE="${APP_RELEASE}" \
    COMPOSER_MEMORY_LIMIT="-1" \
    COMPOSER_ALLOW_SUPERUSER="1"

# info
LABEL maintainer="Vladislav Soprun <develop@soprun.com>"
LABEL com.inspigate.env="${APP_ENV}"
LABEL com.inspigate.debug="${APP_DEBUG}"
LABEL com.inspigate.release="${APP_RELEASE}"
#LABEL com.inspigate.stage="dev"
LABEL com.inspigate.service="php"
LABEL com.inspigate.name="billing"
LABEL com.inspigate.description="..."


# install php-extension-installer
COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/bin/

# install php-extension-installer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# requirements
RUN set -eux; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
        git \
        make \
        bash \
        gnupg \
        openssl \
        curl \
        ca-certificates \
    ; \
    install-php-extensions xdebug memcached opcache pdo_pgsql redis intl apcu; \
    apk del .build-deps

WORKDIR /app

# Use the default production configuration

#RUN set -eux; \
#    chmod +x /usr/local/bin/init.sh;

COPY ./docker/php/init.sh /usr/local/bin/init.sh
COPY ./docker/php/php.ini "${PHP_INI_DIR}/conf.d/php.override.ini"
COPY ./docker/php/php.conf /usr/local/etc/php-fpm.conf
COPY ./docker/php/xdebug.ini "${PHP_INI_DIR}/conf.d/xdebug.ini"

# COPY composer.* /app
# RUN composer install --no-dev --no-scripts --no-suggest --no-interaction --prefer-dist --optimize-autoloader

COPY . .
RUN composer dump-autoload --no-dev --optimize --classmap-authoritative

# ports
EXPOSE 9000

# start up php
CMD "/usr/local/bin/init.sh" && php-fpm --nodaemonize

# CMD ["/usr/local/bin/init.sh"]
