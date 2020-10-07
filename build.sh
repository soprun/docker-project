#!/bin/bash

## Strip git ref prefix from version
#VERSION=$(echo "${{ github.ref }}" | sed -e 's,.*/\(.*\),\1,')
#
## Strip "v" prefix from tag name
#[[ "${{ github.ref }}" == "refs/tags/"* ]] && VERSION=$(echo $VERSION | sed -e 's/^v//')
#
## Use Docker `latest` tag convention
#[ "$VERSION" == "master" ] && VERSION=latest
#

VERSION=$(echo $(git describe --tags --abbrev=0) | sed -e 's,.*/\(.*\),\1,')
VERSION=$(echo $VERSION | sed -e 's/^v//')

# Use Docker `latest` tag convention
if [ "$VERSION" == "master" ]; then
  VERSION=latest
fi

echo $VERSION
#echo $(git rev-parse HEAD)
#echo $(git rev-parse --short HEAD)

exit 0

headname=develop

git show-ref --quiet --verify -- "refs/heads/$headname" ||
  echo "$headname is not a valid branch"

exit 1
# Return git current tag

# Strip git ref prefix from version
VERSION=$(echo $(git describe --tags --abbrev=0) | sed -e 's,.*/\(.*\),\1,')

# Strip "v" prefix from tag name
[[ "$(git describe --tags --abbrev=0)" == "refs/tags/"* ]] && VERSION=$(echo $VERSION | sed -e 's/^v//')

echo $VERSION

exit 0
readonly name="sandbox-php"

tags=(dev prod)

latest

tags

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
