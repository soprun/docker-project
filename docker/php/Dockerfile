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

### Copying source files to workdir
COPY ./app /app

#######################################################################
# Install composer
#######################################################################

COPY --from=soprun/docker-project:composer /composer /composer
COPY --from=soprun/docker-project:composer /usr/bin/composer /usr/bin/composer
