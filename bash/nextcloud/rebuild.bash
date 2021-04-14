#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

cd ./docker/nextcloud/

docker-compose --file default.docker-compose build --no-cache
