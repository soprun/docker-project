# syntax=docker/dockerfile:experimental
# Installation base container
#######################################################################

FROM nginx:1.21-alpine AS base

COPY ./docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /app
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]

#######################################################################
# Installation source container
#######################################################################

FROM base as src
COPY ./app/public/* /app/public

#######################################################################
# Installation dev container
#######################################################################

FROM src as dev

ENV APP_ENV dev
ENV APP_DEBUG 1

#######################################################################
# Installation prod container
#######################################################################

FROM src as prod

ENV APP_ENV prod
ENV APP_DEBUG 0
