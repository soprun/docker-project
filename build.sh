#!/bin/bash

readonly name="sandbox-php"
# readonly tag_latest="latest"
# readonly tag_builder="builder"
readonly tag_development="dev"
readonly tag_production="prod"

readonly container_development="${name}-${tag_development}"
readonly container_production="${name}-${tag_production}"

docker container stop "${container_development}" &>/dev/null
docker container stop "${tag_production}" &>/dev/null
docker container prune --force &>/dev/null

set -ex

docker builder build \
  --file "./docker/php/Dockerfile" \
  --target "${tag_production}" \
  --tag "${name}:${tag_production}" \
  .

docker builder build \
  --file "./docker/php/Dockerfile" \
  --target "${tag_development}" \
  --tag "${name}:${tag_development}" \
  .

docker run \
  --name "${name}-${tag_production}" \
  --detach \
  --rm \
  "${name}:${tag_production}"

docker run \
  --name "${name}-${tag_development}" \
  --detach \
  --rm \
  "${name}:${tag_development}"
