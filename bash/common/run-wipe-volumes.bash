#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

source ./bash/common/wipe-volumes.bash

function run_wipe_volumes() {
  local APP=${1}

  wipe_volumes ${APP}
}

run_wipe_volumes ${@}
