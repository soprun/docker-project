FROM nginx:alpine

ENV \
    APP_ENV="${app_env:-dev}" \
    APP_DEBUG="${app_debug:-1}" \
    APP_VERSION="${APP_VERSION}" \
    APP_RELEASE="${APP_RELEASE}"

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
