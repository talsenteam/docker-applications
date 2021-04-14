#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

function run_down() {
  local APP=${1}

  cd ./docker/${APP}

  docker-compose --file default.docker-compose down
}

run_down ${@}
