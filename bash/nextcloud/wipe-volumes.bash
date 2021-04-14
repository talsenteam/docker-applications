#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

source ./bash/common/wipe-volumes.bash

wipe_volumes nextcloud
