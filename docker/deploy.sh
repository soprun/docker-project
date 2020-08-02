#!/bin/sh

set -eox

#loads env vars into this process
ENV="./.env"
if [ -e $ENV ]; then
  . $ENV
fi

if [ -z "$DOCKER_ATTACHED_MODE" ]; then
  echo "Starting detached containers:"
  docker-compose up --detach --force-recreate --remove-orphans --log-level INFO # ${DOCKER_CONTAINERS}
else
  echo "Starting attached containers:"
  docker-compose up --force-recreate --remove-orphans # ${DOCKER_CONTAINERS}
fi

exit 0