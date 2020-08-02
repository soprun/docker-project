FROM nginx:alpine
LABEL maintainer="Vladislav Soprun <develop@soprun.com>"

ENV APP_ENV="${app_env:-dev}"
ENV APP_DEBUG="${app_debug:-1}"

# copy nginx configuration
COPY ./docker/nginx/server.conf /etc/nginx/server.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/snippets/* /etc/nginx/snippets/

# OpenSSL certificate 🔐
COPY ./docker/nginx/certs/* /etc/ssl/certs/

# change working directory
WORKDIR /app

# Copy the source code from a directory relative to the Dockerfile
# to the `/var/www` directory in the container
COPY ./public /app/public

# forward request and error logs to docker log collector
# RUN ln -sf /dev/stdout /var/log/nginx/access.log \
# 	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]