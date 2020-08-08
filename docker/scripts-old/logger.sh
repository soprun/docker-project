#!/usr/bin/env bash
set -e

tput sgr0

readonly SHELL_SCRIPT_NAME=$(basename $0)

#function log() {
#  logger -p user.debug -t $SHELL_SCRIPT_NAME "$@"
#}
#
#function log-info() {
#  printf "=> \033[0;34m%-6s: \033[0m%-6s\n" 'log.info' "$@"
#  logger -p user.info -t $SHELL_SCRIPT_NAME "$@"
#}
#
#function log-success() {
#  printf "=> \033[0;32m%-6s: \033[0m%-6s\n" 'log.success' "$@"
#  logger -p user.info -t $SHELL_SCRIPT_NAME "$@"
#}
#
#function log-warning() {
#  printf "=> \033[0;33m%-6s: \033[0m%-6s\n" 'log.warn' "$@"
#  logger -p user.warn -t $SHELL_SCRIPT_NAME "$@"
#}
#
#function log-error() {
#  printf "=> \033[0;31m%-6s: \033[0m%-6s\n" 'log.error' "$@" > &2
#  logger -p user.error -t $SHELL_SCRIPT_NAME "$@"
#}
#
#log "debug - writing to stdout.."
#log-info "info - writing to stdout.."
#log-success "success - writing to stdout.."
#log-warning "warning - writing to stdout.."
#log-error "error - writing to stderr.."

function log() {
  printf "=>\033[0;30m log.debug:\033[0m %-6s - %-6s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$@"
  logger -p user.debug -t $SHELL_SCRIPT_NAME "$@"
};

function error() {
  printf "=>\033[0;31m log.error:\033[0m %-6s - %-6s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$@" >&2
  logger -p user.error -t $SHELL_SCRIPT_NAME "$@"
  exit 1
};
