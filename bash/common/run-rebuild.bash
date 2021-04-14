#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

function run_rebuild() {
  local APP=${1}

  cd ./docker/${APP}

  docker-compose --file default.docker-compose build --no-cache
}

run_rebuild ${@}
