FROM nginx:alpine

# nginx config
COPY ./docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./app/public/* /app/public

# workdir
WORKDIR /app

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80 443