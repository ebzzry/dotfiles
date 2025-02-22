#!/usr/bin/env bash

set -euo pipefail

readonly SELF="$(basename ${BASH_SOURCE[0]})"
readonly SELF_DIR="$(cd $(dirname $(readlink -f ${BASH_SOURCE[0]})) >/dev/null 2>&1 && pwd)"
readonly OS="$(uname)"
readonly VERSION="0.0.1"

OPT_HELP=
OPT_DEBUG=
OPT_VERBOSE=
OPT_VERSION=

function error {
  if [[ "${OS}" == "Darwin" ]]; then
    echo "ERROR: ${@}" >&2
  else
    echo -e "\e[0;31m\e[1mERROR: \e[0;0m${@}" >&2
  fi

  exit 1
}

function warning {
  if [[ "${OS}" == "Darwin" ]]; then
    echo "WARNING: ${@}" >&2
  else
    echo -e "\e[0;33mWARNING: \e[0;0m${@}" >&2
  fi
}

function debug {
  if [[ -n "${OPT_DEBUG}" ]]; then
    echo -n "** "
    echo "\${PWD}: ${PWD}"
    echo "\${@}: ${@}"
  fi
}

function push {
  debug "${FUNCNAME[0]}" "${@}"

  pushd "${1}" &>/dev/null
}

function pop {
  debug "${FUNCNAME[0]}" "${@}"

  popd &>/dev/null
}

function parse_arguments {
  debug "${FUNCNAME[0]}" "${@}"

  local opts=$(getopt -n "${SELF}" --options n:e --longoptions help,debug,verbose,version -- "${@}")

  if [[ $? != 0 ]]; then
    error "Failed to parse arguments. Aborting."
  fi

  eval set -- "${opts}"

  while true; do
    case "$1" in
    --help)
      OPT_HELP=true
      shift
      ;;
    --debug)
      OPT_DEBUG=true
      shift
      ;;
    --verbose)
      OPT_VERBOSE=true
      shift
      ;;
    --version)
      OPT_VERSION=true
      shift
      ;;
    --)
      shift
      break
      ;;
    *) break ;;
    esac
  done
}

function process_arguments {
  debug "${FUNCNAME[0]}" "${@}"

  if [[ -n "${OPT_HELP}" || "${#}" -lt 1 ]]; then
    display_usage
  elif [[ -n "${OPT_VERSION}" ]]; then
    display_version
  else
    return 0
  fi
}

function display_usage {
  debug "${FUNCNAME[0]}" "${@}"

  cat <<EOF
${SELF} v${VERSION} [OPTIONS]...

OPTIONS:
      --help                        Show this help
      --debug                       Enable debugging mode
      --verbose                     Enable verbose output
      --version                     Display program version info
EOF
  exit 0
}

function display_version {
  debug "${FUNCNAME[0]}" "${@}"

  cat <<EOF
${SELF} v${VERSION}
EOF
  exit 0
}

function dispatch {
  debug "${FUNCNAME[0]}" "${@}"
}

function main {
  debug "${FUNCNAME[0]}" "${@}"

  parse_arguments "${@}"
  process_arguments "${@}"
  dispatch "${@}"
}

main "${@}"
