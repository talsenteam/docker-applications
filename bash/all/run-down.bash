#!/bin/bash

set -euo pipefail

source ./bash/common/list-available-apps.bash

function run_down() {
  echo "info: stopping and removing all apps"

  for X in $( list_available_apps )
  do
    echo "info: ${X}"
    /bin/bash \
      ./bash/common/run-down.bash \
      ${X}
  done
}

run_down
