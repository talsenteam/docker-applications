#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

function run_upgrade() {
  local APP=${1}

  cd ./docker/${APP}

  docker-compose --file upgrade.docker-compose up
}

run_upgrade ${@}
