#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

/bin/bash \
  ./bash/common/elevate.bash \
  root \
  ./bash/all/run-down.bash
