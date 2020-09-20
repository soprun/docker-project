###
### Installation container
###

FROM nginx:alpine

###
### Environment variables
###

###
### Copy files nginx configuration
###

COPY ./docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
#COPY ./docker/nginx/snippets/* /etc/nginx/snippets/
#COPY ./docker/nginx/ssl/* /etc/nginx/ssl/

###
### Change working directory
###

WORKDIR /app

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
