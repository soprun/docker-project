#!/usr/bin/env bash

set -e
set -u
set -o pipefail

clear -x

###
### Globals
###

DOCKER_DEBUG=0
DOCKER_DETACHED_MODE=1

DOCKER_PROJECT_PATH=
DOCKER_PROJECT_NAME=