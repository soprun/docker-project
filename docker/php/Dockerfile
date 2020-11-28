FROM soprun/docker-project:base AS dev

# persistent dependencies
RUN set -eux \
  && apk add --no-cache \
    curl \
    bash \
    git \
    vim \
    make

# Use the default development configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
