#!/bin/bash

set -euo pipefail

function output
{
  local style_start=""
  local style_end=""
  if [ "${2:-}" != "" ]; then
    case $2 in
    "success")
      style_start="\033[0;32m"
      style_end="\033[0m"
      ;;
    "error")
      style_start="\033[31;31m"
      style_end="\033[0m"
      ;;
    "info" | "warning")
      style_start="\033[33m"
      style_end="\033[39m"
      ;;
    "heading")
      style_start="\033[1;33m"
      style_end="\033[22;39m"
      ;;
    esac
  fi

  builtin echo -e "${style_start}${1}${style_end}"
}

# Project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Run environment checks.
output "\nEnvironment check" "heading"
output "\n${PROJECT_DIR}" "info"

ls -la $PROJECT_DIR

exit 0

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
