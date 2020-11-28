ARG NGINX_VERSION="alpine"
ARG APP_ENV="dev"
ARG APP_DEBUG="1"

FROM nginx:${NGINX_VERSION} AS build

ARG APP_ENV
ARG APP_DEBUG
ARG APP_DIR

ENV APP_ENV=$APP_ENV
ENV APP_DEBUG=$APP_DEBUG

# nginx config
COPY ./docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./app/public/* /app/public

# workdir
WORKDIR /app

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80 443

FROM build AS dev

FROM build AS prod

ARG APP_ENV
ARG APP_DEBUG

ENV APP_ENV="${APP_ENV:-prod}"
ENV APP_DEBUG="${APP_DEBUG:-0}"