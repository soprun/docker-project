#!/bin/sh

set -e

ECHO=$(which echo);
PING=$(which ping);

function check_env() {
  if [ $ENV != "prod" ] && [ $1 == "set" ]; then
    set -o errtrace # fail and exit on first error
    set -o xtrace   # show all output to console while writing script
  fi
  if [ $ENV != "prod" ] && [ $1 == "unset" ]; then
    set +o errtrace
    set +o xtrace
  fi
}

# check ip, if alive do command
# usage: check_ip 192.168.1.1 ALIVE=1
function check_ip() {
  # check if ip is alive, if so then true and do this
  $PING -c 1 -w 5 $1 &>/dev/null

  if [ $? -ne 0 ]; then
    debug "host $1 down. . ."
  else
    $2
  fi
}

function wait_til_done() {
  $1
  wait
}

function paralell_exec() {
  # fire off multiple bg jobs
  $ECHO
}

function load_env() {
  local file="$(pwd)/$1"

  if [ -e $file ]; then
    . $file

    log "${file} file has been load."
  fi
}

function env_value() {
  echo $1;
  echo $2;
}