###
### Installation container
###

FROM php:${PHP_VERSION:-7.4}-fpm-alpine AS build

###
### Environment variables
###

ENV \
    TZ=UTC \
    LANG=en_US.UTF8 \
    LANGUAGE=en

###
### Labels
### https://github.com/opencontainers/image-spec/blob/master/annotations.md
###

LABEL \
    com.app.env="${APP_ENV}" \
    com.app.debug="${APP_DEBUG}" \
    com.app.git_tag="${GIT_TAG}" \
    com.app.git_branch="${GIT_BRANCH}" \
    com.app.git_commit_id="${GIT_COMMIT_ID}" \
    com.app.git_commit_sha="${GIT_COMMIT_SHA}" \
    com.app.project_name="${PROJECT_NAME}" \
    com.app.tier="backend" \
    com.app.name="php" \
    com.app.host="${APP_HOST}" \
    com.app.title="..." \
    com.app.description="..." \
    com.app.vendor="inspiritum.com" \
    com.app.authors="Vladislav Soprun <develop@soprun.com>" \
    com.app.source="https://github.com/soprun/docker-project" \
    com.app.documentation="https://github.com/soprun/docker-project/wiki"

###
### Install
###
#RUN set -eu \
#    apk --no-cache add \
#    gnupg \
#    bash \
#    bash-completion \
#    openssl \
#    openssh-client \
#    curl \
#    vim \
#    git

###
### Copy configuration files
###

COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.ini
COPY ./docker/php/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY ./docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

####
#### Install composer
####
#
##ENV COMPOSER_MEMORY_LIMIT="-1"
##ENV COMPOSER_ALLOW_SUPERUSER="1"
##ENV PATH="${PATH}:/root/.composer/vendor/bin"
#
#COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

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

WORKDIR /app

###
### Copy source files to workdir
###

COPY . /app

###
### Install dependencies
###

#RUN set -eu \
#    chmod +x /usr/local/bin/docker-entrypoint; \
#    composer install \
#        --ignore-platform-reqs \
#        --no-scripts \
#        --optimize-autoloader \
#        --classmap-authoritative \
#        --profile;

###
### Expose port
###

EXPOSE 9000

###
### Entrypoint
###

#ENTRYPOINT ["docker-entrypoint"]
#COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
#ENTRYPOINT ["docker-entrypoint.sh"]

###
### Startup
###

CMD ["php-fpm", "--nodaemonize"]