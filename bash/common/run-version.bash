#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

function run_version() {
  local APP=${1}

  cd ./docker/${APP}

  docker-compose --file version.docker-compose up
}

run_version ${@}
