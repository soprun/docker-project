#!/bin/sh

tput sgr0

readonly SHELL_SCRIPT_NAME=$(basename $0)

function log() {
  logger -p user.debug -t $SHELL_SCRIPT_NAME "$@"
}

function log_info() {
  printf "=>\033[0;34m log.info: \033[0m%-6s\n" "$@"
  logger -p user.info -t $SHELL_SCRIPT_NAME "$@"
}

function error() {
  printf "=>\033[0;31m log.error: \033[0m%-6s\n" "$@" >&2
  logger -p user.error -t $SHELL_SCRIPT_NAME "$@"
  exit 1
}

function dump_env() {
  log_info $(printenv | sort | less)
  exit 1
}
