#!/bin/bash

set -euo pipefail

cd /data

VAR_NAME_USER=${1}
VAR_PASS_USER=${2}

if ! [[ "${VAR_NAME_USER}" =~ ^[0-9a-zA-Z.-]+$ ]]; then
  echo >&2 "Error: Provided user name '${VAR_NAME_USER}' contains invalid characters."
  exit 1
fi

if [ "${VAR_PASS_USER}" = "" ]; then
  echo >&2 "Error: No password provided."
  exit 1
fi

export "ENV_NAME_USER=${VAR_NAME_USER}"
export "ENV_PASS_USER=${VAR_PASS_USER}"

/usr/bin/expect /opt/matrix-synapse/register-matrix-user.expect
