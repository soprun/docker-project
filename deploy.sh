#!/bin/sh

set -e

# export APP_SECRET=$(openssl rand -hex 16);
# export APP_RELEASE=$(git rev-parse HEAD);
# echo "secret: ${APP_SECRET}"
# echo "release: ${APP_RELEASE}"

docker build \
	--file ./docker/nginx/Dockerfile \
	--tag sandbox/nginx \
	.

# todo: Set label when building image.
#LABEL com.inspigate.app.type="php"
#LABEL com.inspigate.app.debug="false"
#LABEL com.inspigate.app.name="billing"
#LABEL com.inspigate.app.description=""
#LABEL com.inspigate.server.ssl=""
#LABEL com.inspigate.server.external_port=""
##LABEL com.inspigate.version="${APP_VERSION}"
##LABEL com.inspigate.release="${APP_RELEASE}"
#LABEL com.inspigate.stage="builder"
#LABEL com.inspigate.description="..."

docker build \
	--build-arg app_env=dev \
	--build-arg app_debug=true \
	--file ./docker/php-cli/Dockerfile \
	--tag sandbox/php-cli \
	.

docker build \
	--build-arg app_env=dev \
	--build-arg app_debug=true \
	--file ./docker/php-fpm/Dockerfile \
	--tag sandbox/php-fpm \
	.

docker-compose up --build --detach --force-recreate --remove-orphans

docker run -it --rm --volume $(pwd):/app sandbox/php-fpm composer install