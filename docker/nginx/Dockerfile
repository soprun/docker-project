ARG APP_ENV
ARG APP_DEBUG

FROM nginx:alpine AS builder

ENV \
    APP_ENV="${APP_ENV:-dev}" \
    APP_DEBUG="${APP_DEBUG:-1}"

LABEL maintainer="Vladislav Soprun <develop@soprun.com>"

###
### Copy files nginx configuration
###

COPY ./docker/nginx/server.conf /etc/nginx/server.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/snippets/* /etc/nginx/snippets/

###
### OpenSSL certificate 🔐
###

COPY ./docker/nginx/certs/* /etc/ssl/certs/

###
### Change working directory
###

WORKDIR /app

###
### Copy files
###

COPY /public /app/public

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
