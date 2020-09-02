###
### Installation container
###

FROM nginx:alpine AS builder

ARG APP_DIR
ARG APP_ENV
ARG APP_DEBUG

###
### Environment variables
###

ENV APP_DIR="${APP_DIR:-/var/www/html}"
ENV APP_ENV="${APP_ENV:-dev}"
ENV APP_DEBUG="${APP_DEBUG:-1}"

###
### Copy files nginx configuration
###

COPY ./docker/nginx/server.conf /etc/nginx/server.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/snippets/* /etc/nginx/snippets/

###
### OpenSSL certificate 🔐
###

COPY ./docker/nginx/ssl/* /etc/nginx/ssl/

###
### Change working directory
###

WORKDIR /var/www/html

###
### Copy files
###

COPY ./public /var/www/html/public

# forward request and error logs to docker log collector
# RUN ln -sf /dev/stdout /var/log/nginx/access.log \
# 	&& ln -sf /dev/stderr /var/log/nginx/error.log

###
### Ports
###
EXPOSE 80 443

###
### Start up
###

CMD ["nginx", "-g", "daemon off;"]
