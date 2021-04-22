#!/bin/bash

set -euo pipefail

cd /data

VAR_NAME_USER=${1}

VAR_DOMAIN_MATRIX=${SERVER_NAME}

if ! [[ "${VAR_NAME_USER}" =~ ^[0-9a-zA-Z.]+$ ]]; then
  echo >&2 "Error: Provided user name '${VAR_NAME_USER}' contains invalid characters."
  exit 1
fi

if ! [[ "${VAR_DOMAIN_MATRIX}" =~ ^[0-9a-zA-Z.]+$ ]]; then
  echo >&2 "Error: Provided matrix domain '${VAR_DOMAIN_MATRIX}' contains invalid characters."
  exit 1
fi

VAR_SQL_COMMAND="UPDATE users SET admin='1' WHERE name='@${VAR_NAME_USER}:${VAR_DOMAIN_MATRIX}';"

sqlite3 homeserver.db "${VAR_SQL_COMMAND}"
