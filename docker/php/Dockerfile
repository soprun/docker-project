###
### Installation container
###

FROM php:7.4-fpm-alpine AS build

ARG APP_DIR
ARG APP_ENV
ARG APP_DEBUG
ARG APP_SECRET
ARG APP_RELEASE

###
### Labels
### https://github.com/opencontainers/image-spec/blob/master/annotations.md
###

LABEL \
    com.app.env="${APP_ENV}" \
    com.app.debug="${APP_DEBUG}" \
    com.app.release="${APP_RELEASE}" \
    com.app.commit_id="${APP_COMMIT_ID}" \
    com.app.commit_sha="${APP_COMMIT_SHA}" \
    com.app.namespace="billing" \
    com.app.name="php" \
    com.app.title="Billing api service." \
    com.app.description="..." \
    com.app.vendor="inspiritum.com" \
    com.app.authors="Vladislav Soprun <develop@soprun.com>" \
    com.app.source="https://github.com/soprun/docker-project" \
    com.app.documentation="https://github.com/soprun/docker-project/wiki"

###
### Environment variables
###

ENV APP_DIR="${APP_DIR:-/var/www/html}"
ENV APP_ENV="${APP_ENV:-dev}"
ENV APP_DEBUG="${APP_DEBUG:-1}"

###
### Context environment
###

ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"
ENV PATH="${PATH}:${APP_DIR}/bin"
#ENV PATH="${PATH}:${APP_DIR}/vendor/bin"

###
### Install
###

RUN apk --no-cache add \
    bash \
    bash-completion \
    git \
    make \
    gnupg \
    openssl \
    curl \
    ca-certificates \
    vim

# install php-extension-installer
COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/bin/

RUN install-php-extensions \
    xdebug \
    memcached \
    opcache \
    pdo \
    pdo_pgsql \
    redis \
    intl \
    apcu \
    curl \
    zip \
    soap \
    imap \
    http \
    ssh2 \
    openssl \
    sockets

#RUN apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
#    libzip-dev \
#    imap-dev \
#    libxml2-dev \
#    postgresql-dev \
#    libmemcached-dev \
#    openssl-dev \
#    libssh2-dev \
#    curl-dev
#
#RUN docker-php-ext-configure \
#    imap --with-imap-ssl
#
#RUN docker-php-ext-install \
#    pgsql \
#    pdo \
#    pdo_pgsql \
#    zip \
#    opcache \
#    intl \
#    sockets \
#    soap \
#    curl \
#    imap
#
#RUN pecl install memcached-3.1.4 \
#    && docker-php-ext-enable memcached
#
#RUN pecl install redis-5.1.1 \
#    && docker-php-ext-enable redis
#
#RUN pecl install xdebug-2.8.1 \
#    && docker-php-ext-enable xdebug
#
#RUN pecl install apcu \
#    && docker-php-ext-enable apcu
#
#RUN pecl install ssh2-1.1.2 \
#    && docker-php-ext-enable ssh2
#
#RUN pecl install raphf propro \
#    && docker-php-ext-enable raphf propro
#
#RUN pecl install pecl_http \
#    && docker-php-ext-enable http
#
#RUN rm -rf /var/cache/apk/* && rm -rf /tmp/*
#RUN docker-php-source delete
#RUN apk del .build-deps

###
### Copy configuration files
###

COPY ./docker/php/php.ini "/usr/local/etc/php/conf.d/php.ini,"
COPY ./docker/php/php-fpm.conf "/usr/local/etc/php-fpm.conf"
COPY ./docker/php/docker-entrypoint.sh "/usr/local/bin/docker-entrypoint.sh"

###
### Install composer
###

ENV COMPOSER_MEMORY_LIMIT="-1"
ENV COMPOSER_ALLOW_SUPERUSER="1"
ENV PATH="${PATH}:/root/.composer/vendor/bin"

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

###
### Install composer
###

# RUN curl --location --output /usr/local/bin/composer https://getcomposer.org/composer-stable.phar
# RUN chmod +x /usr/local/bin/composer

###
### Install phpunit
###

# RUN curl --location --output /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar
# RUN chmod +x /usr/local/bin/phpunit

###
### Change working directory
###

#RUN set -ex; \
#	mkdir -p "${APP_DIR}"; \
#	chown -R www-data:www-data "${APP_DIR}"

WORKDIR "${APP_DIR}"

###
### Copy source files to workdir
###

COPY . "${APP_DIR}"

###
### Install dependencies
###

RUN set -eux; \
    chmod +x /usr/local/bin/docker-entrypoint.sh; \
    composer global require hirak/prestissimo \
        --ignore-platform-reqs \
        --quiet \
        --profile; \
    composer install \
        --ignore-platform-reqs \
        --no-scripts \
        --optimize-autoloader \
        --classmap-authoritative;

###
### Expose port
###

EXPOSE 9000

###
### Entrypoint
###

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

###
### Startup
###

# USER www-data

CMD ["php-fpm", "--nodaemonize"]