#!/bin/bash

set -euo pipefail

source ./bash/common/list-available-apps.bash

function run_wipe_volumes() {
  echo "info: wiping volumes of all available apps"

  for X in $( list_available_apps )
  do
    echo "info: ${X}"
    /bin/bash \
      ./bash/common/run-wipe-volumes.bash \
      ${X}
  done
}

run_wipe_volumes
