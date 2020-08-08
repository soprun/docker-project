ARG APP_ENV
ARG APP_DEBUG
ARG APP_SECRET
ARG APP_RELEASE
ARG APP_COMMIT_SHA

FROM nginx:alpine AS builder

ENV \
    APP_ENV="${APP_ENV:-dev}" \
    APP_DEBUG="${APP_DEBUG:-1}" \
    APP_SECRET="${APP_SECRET}" \
    APP_RELEASE="${APP_RELEASE}" \
    APP_COMMIT_SHA="${APP_COMMIT_SHA}"

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

WORKDIR /app/public

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
