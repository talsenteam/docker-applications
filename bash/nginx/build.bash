#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

cd ./docker/nginx/

docker-compose --file default.docker-compose build
