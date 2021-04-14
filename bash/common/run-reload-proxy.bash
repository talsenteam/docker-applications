#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

function run_reload_proxy() {
  local APP=${1}

  cd ./docker/${APP}/

  docker-compose --file default.docker-compose exec proxy /bin/bash /opt/server--nginx-certbot/command-update-configuration.sh proxy.env
}

run_reload_proxy ${@}
