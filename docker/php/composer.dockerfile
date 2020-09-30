### Installation composer container
FROM composer:latest AS composer

ARG COMPOSER_HOME

### Environment variables
ENV COMPOSER_HOME="$COMPOSER_HOME"
ENV COMPOSER_CACHE_DIR="${COMPOSER_HOME}/cache"
# ENV COMPOSER_MEMORY_LIMIT="-1"
# ENV COMPOSER_ALLOW_SUPERUSER="1"

WORKDIR /app
COPY ./app/composer.* /app
COPY ./app/symfony.lock /app

RUN set -e; \
    ## Install composer plugin
    composer global require hirak/prestissimo \
        --no-progress \
        --no-scripts \
        --no-interaction \
        --profile
