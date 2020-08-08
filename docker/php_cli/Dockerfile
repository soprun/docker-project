FROM php:7.4-cli-alpine

RUN apk update && apk add --no-cache $PHPIZE_DEPS \
    bash \
    git

WORKDIR /app
COPY . /app
