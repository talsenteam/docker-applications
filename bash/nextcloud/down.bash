#!/bin/bash

set -euo pipefail

cd ./docker/nextcloud/

docker-compose --file default.docker-compose down
