#!/usr/bin/env bash

set -e
set -u
set -o pipefail


###
### Globals
###

# Path to scripts to source
CONFIG_DIR="/docker-entrypoint.d"


############################################################
# Functions
############################################################

###
### Log to stdout/stderr
###
log() {
	local type="${1}"     # ok, warn or err
	local message="${2}"  # msg to print
	local debug="${3}"    # 0: only warn and error, >0: ok and info

	local clr_ok="\033[0;32m"
	local clr_info="\033[0;34m"
	local clr_warn="\033[0;33m"
	local clr_err="\033[0;31m"
	local clr_rst="\033[0m"

	if [ "${type}" = "ok" ]; then
		if [ "${debug}" -gt "0" ]; then
			printf "${clr_ok}[OK]   %s${clr_rst}\n" "${message}"
		fi
	elif [ "${type}" = "info" ]; then
		if [ "${debug}" -gt "0" ]; then
			printf "${clr_info}[INFO] %s${clr_rst}\n" "${message}"
		fi
	elif [ "${type}" = "warn" ]; then
		printf "${clr_warn}[WARN] %s${clr_rst}\n" "${message}" 1>&2	# stdout -> stderr
	elif [ "${type}" = "err" ]; then
		printf "${clr_err}[ERR]  %s${clr_rst}\n" "${message}" 1>&2	# stdout -> stderr
	else
		printf "${clr_err}[???]  %s${clr_rst}\n" "${message}" 1>&2	# stdout -> stderr
	fi
}

###
### Is env variable set?
###
env_set() {
	printenv "${1}" >/dev/null 2>&1
}


###
### Get env variable by name
###
env_get() {
	local env_name="${1}"

	# Did we have a default value specified?
	if [ "${#}" -gt "1" ]; then
		if ! env_set "${env_name}"; then
			echo "${2}"
			return 0
		fi
	fi
	# Just output the env value
	printenv "${1}"
}


############################################################
# Sanity Checks
############################################################

if ! command -v printenv >/dev/null 2>&1; then
	log "err" "printenv not found, but required." "1"
	exit 1
fi

###
### Set Debug level
###
DEBUG_LEVEL="$( env_get "DEBUG_ENTRYPOINT" "0" )"

log "info" "Debug level: ${DEBUG_LEVEL}" "${DEBUG_LEVEL}"

###
### Startup
###
log "info" "Starting $( php-fpm -v 2>&1 | head -1 )" "${DEBUG_LEVEL}"

exec "${@}"