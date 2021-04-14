#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

function run_up() {
  local APP=${1}

  cd ./docker/${APP}

  docker-compose --file default.docker-compose up --detach
}

run_up ${@}
