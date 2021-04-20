#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

function run_setup() {
  local APP=${1}

  cd ./docker/${APP}

  docker-compose --file setup.docker-compose up
}

run_setup ${@}
