#!/bin/bash

set -euo pipefail

cd ./docker/nginx/

docker-compose --file default.docker-compose up --detach
