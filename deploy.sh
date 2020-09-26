#!/bin/bash

#eval $(docker-machine env default)

if ! docker --version >/dev/null 2>/dev/null; then
  error 'Command "docker" is not installed.'
fi

if ! docker-compose --version >/dev/null 2>/dev/null; then
  error 'Command "docker-compose" is not installed.'
fi

# Load up .env
set -o allexport
[[ -f "./docker/.env" ]] && source "./docker/.env"
set +o allexport

function build() {
  docker-compose up \
    --detach \
    --force-recreate \
    --remove-orphans \
    --renew-anon-volumes
}

function start() {
  build # Call task dependency
  # python -m SimpleHTTPServer 9000
}

function default() {
  # Default task to execute
  start
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-default}

#build
#deploy

"$@"
