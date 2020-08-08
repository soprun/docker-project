#!/usr/bin/env bash

tput sgr0

readonly SHELL_SCRIPT_NAME=$(basename $0)

function log() {
  logger -p user.debug -t $SHELL_SCRIPT_NAME "$@"
}

function log-info() {
  printf "=>\033[0;34m log.info:\033[0m %-6s - %-6s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$@"
  logger -p user.info -t $SHELL_SCRIPT_NAME "$@"
}

function error() {
  printf "=>\033[0;31m log.error:\033[0m %-6s - %-6s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$@" >&2
  logger -p user.error -t $SHELL_SCRIPT_NAME "$@"
  exit 1
}
