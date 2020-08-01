#!/bin/sh

docker build --tag sandbox/php-fpm:7.4 .

# and the latest tag also
docker build --tag sandbox/php-fpm ../../../