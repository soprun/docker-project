#!/usr/bin/env bash

set -e
set -u
set -o pipefail

###
### Globals
###

echo "docker-entrypoint.sh"

exec "${@}"
