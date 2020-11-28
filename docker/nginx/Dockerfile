FROM nginx:alpine

# nginx config
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

# workdir
WORKDIR /app

CMD ["nginx"]

EXPOSE 80 443