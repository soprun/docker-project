ARG NGINX_VERSION=1.19

FROM nginx:${NGINX_VERSION}-alpine AS builder

###
### Copy source files to workdir
###

WORKDIR /app

COPY ./app/public/ /app/public/
COPY ./docker/nginx/snippets/ /etc/nginx/snippets/
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/default.conf /etc/nginx/sites-available/default.conf

###
### Docker entrypoint
###

COPY ./docker/nginx/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
