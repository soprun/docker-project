FROM php:7.4-cli-alpine

ARG APP_ENV
ARG PHP_DEBUG

RUN apk update && apk add --no-cache $PHPIZE_DEPS \
    bash \
    git

# WORKDIR /app
# COPY . /app