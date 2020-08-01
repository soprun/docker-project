FROM nginx:1.15.8-alpine

WORKDIR /app

COPY public/index.php /app/public/index.php

COPY docker/nginx/app.conf /etc/nginx/conf.d/default.conf
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf