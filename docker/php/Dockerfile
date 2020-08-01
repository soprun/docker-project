FROM composer:1.8.5 as composer

COPY composer.* /app/

RUN set -xe \
 && composer install --no-dev --no-scripts --no-suggest --no-interaction --prefer-dist --optimize-autoloader

COPY . /app

RUN composer dump-autoload --no-dev --optimize --classmap-authoritative

FROM php:7.2.13-fpm-alpine3.8
 
RUN apk update \
 && apk add --no-cache $PHPIZE_DEPS \
    git \
    zip \
    unzip \
 && docker-php-ext-install \
    opcache \
    pdo_mysql \
 && docker-php-ext-enable \
    opcache \
 && rm -rf \
    /var/cache/apk/* \
    /var/lib/apt/lists/*
 
WORKDIR /app
 
COPY . /app
 
COPY --from=composer /app/vendor /app/vendor
 
COPY docker/php/php.ini /usr/local/etc/php/conf.d/php.override.ini
COPY docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY docker/php/init.sh /usr/local/bin/init.sh
 
RUN chmod +x /usr/local/bin/init.sh

CMD ["/usr/local/bin/init.sh"]