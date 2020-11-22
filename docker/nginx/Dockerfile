FROM nginx:latest

COPY ./.shared/scripts/ /tmp/scripts/
RUN chmod -R 777 /tmp/scripts/

# set timezone
#ARG TZ=UTC
#RUN /tmp/scripts/set_timezone.sh ${TZ}

# add users
ARG APP_USER=www-data
ARG APP_GROUP=www-data
ARG APP_USER_ID=1000
ARG APP_GROUP_ID=1000

# nginx config
COPY ./nginx/nginx.conf /etc/nginx/
#ARG APP_USER
#RUN /tmp/scripts/modify_config.sh /etc/nginx/nginx.conf \
#    "__APP_USER" \
#    "${APP_USER}" \
# && /tmp/scripts/modify_config.sh /etc/nginx/nginx.conf \
#    "__APP_GROUP" \
#    "${APP_GROUP}" \
#;

# nginx app config
COPY ./nginx/sites-available/* /etc/nginx/sites-available/

#ARG APP_CODE_PATH
#RUN /tmp/scripts/modify_config.sh /etc/nginx/sites-available/default.conf \
#    "__NGINX_ROOT" \
#    "${APP_CODE_PATH}" \
#;

# workdir
WORKDIR /etc/nginx/

# cleanup
RUN /tmp/scripts/cleanup

CMD ["nginx"]

EXPOSE 80 443
