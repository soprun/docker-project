#!/usr/bin/bash bash

#set -e

source './docker/scripts/functions.sh'



APP_ENVSS=$(env_value APP_ENV 'dev')


echo "---- $APP_ENVSS";
echo "---- $APP_ENV";