###
### Installation container
###

FROM nginx:alpine AS builder

ARG APP_ENV
ARG APP_DEBUG

###
### Environment variables
###

ENV \
    TZ=UTC \
    LANG=en_US.UTF8 \
    LANGUAGE=en \
    APP_DIR=${APP_DIR:-/app} \
    APP_ENV="${APP_ENV:-dev}" \
    APP_DEBUG="${APP_DEBUG:-1}" \
    PATH="${PATH}:${APP_BIN_DIR}"

###
### Copy files nginx configuration
###

COPY ./docker/nginx/server.conf /etc/nginx/server.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/snippets/* /etc/nginx/snippets/
COPY ./docker/nginx/ssl/* /etc/nginx/ssl/

###
### Change working directory
###

WORKDIR ${APP_DIR}

###
### Copy files
###

COPY ./public /app/public

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
