#!/bin/sh

log_info() {
  printf "\033[0;34m[info]\033[0m: %s\\n" "$1"
}

log_success() {
  printf "\033[0;32m[success]\033[0m: %s\\n" "$1"
}

log_warn() {
  printf "\033[0;33m[warn]\033[0m: %s\\n" "$1"
}

log_error() {
  printf "\033[0;31m[error]\033[0m: %s\\n" "$1"
}

log_title() {
  printf "\n\033[0;30m->> \033[0;32m%s\033[0m\\n" "$1"
}

error_exit() {
  log_error "$1" >&2
  exit 1
}

# Fail fast with concise message when cwd does not exist
if ! [[ -d "$PWD" ]]; then
  error_exit "Error: The current working directory doesn't exist, cannot proceed." >&2
fi

# Project directory
readonly PROJECT_DIR="$(dirname $(cd -P -- "$(dirname -- "$0")" && pwd -P))"
export PROJECT_DIR

# Load the shell .env files
for file in ${PROJECT_DIR}/{docker/.env,docker/.env.local,app/.env,app/.env.local}; do
  # shellcheck source=
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

if [ -z "$PROJECT_NAME" ]; then
  error_exit "An error occurred, the value of the variable PROJECT_NAME was not loaded!"
fi

if [ -z "$APP_ENV" ]; then
  error_exit "An error occurred, the value of the variable APP_ENV was not loaded!"
fi
