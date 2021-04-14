#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

cd ./docker/kimai/

docker-compose --file default.docker-compose down
