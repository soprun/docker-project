#!/bin/bash

#!/bin/bash

set -e

log_info() {
  printf "\033[0;34m[info]\033[0m: %s\\n" "$1"
}

# Project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# shellcheck source=./.env
source "${PROJECT_DIR}/../.env"

IMAGE="${DOCKER_USER}/${DOCKER_REPOSITORY}"

GIT_VERSION=$(git describe --tags --abbrev=0)
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_COMMIT_SHA=$(git rev-parse HEAD)
GIT_COMMIT_ID=$(git rev-parse --short=7 HEAD)

log_info $IMAGE
log_info $PROJECT_NAME
log_info $GIT_VERSION
log_info $GIT_BRANCH
log_info $GIT_COMMIT_ID
log_info $GIT_COMMIT_SHA

#exit 0

docker build . \
  --file "${PROJECT_DIR}/php/Dockerfile" \
  --tag "${IMAGE}:dev" \
  --target "dev"

#docker build \
#  --file "${PROJECT_DIR}/php/Dockerfile" \
#  --tag "${IMAGE}:dev" \
#  --target "dev" \
#  ${PROJECT_DIR}
