#!/bin/bash

source ./docker/scripts/logger.sh

# For bash shells:
set -euo pipefail

if ! type docker &>/dev/null; then
  error "docker command not found."
fi

# export APP_DIR="$(pwd)"
#source "${APP_DIR}/.env"

# jq -s 'map(.[].name)' build.json

#if [ ${#task_list[@]} -eq 0 ]; then
#  error "empty task_list"
#fi

# initialize arrays a b c

#array=([file: 23] 45 34 1 2 3)
##To refer to all the array values
#echo ${array[@]}

#for i in (); do
#  echo "Looping ... number $i"
#done

## basic construct
#for arg in [list]
#do
# command(s)...
#done
