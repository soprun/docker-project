###
### Installation container
###

FROM php:${PHP_VERSION:-7.4}-fpm-alpine

###
### Environment variables
###

ENV TZ=UTC
ENV LANG=en_US.UTF8
ENV LANGUAGE=en

ENV PATH="${PATH}:/app/bin"
ENV PATH="${PATH}:/composer/vendor/bin"

###
### Labels
### https://github.com/opencontainers/image-spec/blob/master/annotations.md
###

LABEL \
    com.app.env="${APP_ENV}" \
    com.app.debug="${APP_DEBUG}"
#    com.app.git_tag="${GIT_TAG}" \
#    com.app.git_branch="${GIT_BRANCH}" \
#    com.app.git_commit_id="${GIT_COMMIT_ID}" \
#    com.app.git_commit_sha="${GIT_COMMIT_SHA}" \
#    com.app.project_name="${PROJECT_NAME}" \
#    com.app.tier="backend" \
#    com.app.name="php" \
#    com.app.host="${APP_HOST}" \
#    com.app.title="..." \
#    com.app.description="..." \
#    com.app.vendor="inspiritum.com" \
#    com.app.authors="Vladislav Soprun <develop@soprun.com>" \
#    com.app.source="https://github.com/soprun/docker-project" \
#    com.app.documentation="https://github.com/soprun/docker-project/wiki"

###
### Install OS-level dependencies - persistent / runtime deps
### Install language-level dependencies
###

#RUN set -eu; \
#	apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
#        libzip-dev \
#        libmemcached-dev \
#        postgresql-dev \
#        openssl \
#        openssh-client \
#        ca-certificates \
#        git \
#        curl \
#        zip \
#        vim \
#        gnupg \
#        bash \
#        make \
#        autoconf \
#        make \
#    && docker-php-ext-install \
#        pdo \
#        pdo_pgsql \
#        pgsql \
#        opcache \
#        intl \
#        zip \
#    && RUN rm -rf /var/cache/apk/* \
#    && rm -rf /tmp/* \
#    && apk del .build-deps

#&& pecl install xdebug-2.8.1 \
#&& docker-php-ext-enable xdebug
#&& pecl install redis-5.1.1 \
#&& docker-php-ext-enable  redis \
#&& pecl install memcached-3.1.4 \
#&& docker-php-ext-enable memcached \
#&& docker-php-source delete \

###
### Copy configuration files
###

# Use the default production configuration
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# /usr/local/etc/php/php.ini
COPY ./docker/php/php.ini "$PHP_INI_DIR/php.ini"
COPY ./docker/php/php-fpm.conf /usr/local/etc/php-fpm.conf

###
### Install extensions and utilities
###

ENV COMPOSER_HOME=/composer
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_ALLOW_SUPERUSER=1

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

###
### Change working directory
###

WORKDIR /app

###
### Copy source files to workdir
###

COPY . /app

#RUN \
## Install composer
# curl --location --output /usr/local/bin/composer https://getcomposer.org/composer-stable.phar; \
# chmod +x /usr/local/bin/composer; \
## Install phpunit
# curl --location --output /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar; \
# chmod +x /usr/local/bin/phpunit; \
## composer check-platform-reqs
# composer check-platform-reqs; \
## Install composer plugin
# composer global require hirak/prestissimo; \
## Compiles .env files to .env.local.php.
# composer symfony:dump-env dev; \
## Install application dependencies
# composer install \
#     --no-scripts \
#     --optimize-autoloader \
#     --classmap-authoritative \
#     --profile; \

###
### Mount
###

VOLUME ["/app"]

###
### Entrypoint
###

#COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
#RUN chmod +x /usr/local/bin/docker-entrypoint;
#ENTRYPOINT ["docker-entrypoint"]

###
### Startup
###

CMD ["php-fpm", "--nodaemonize"]
