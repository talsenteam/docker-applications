#!/bin/bash

set -euo pipefail

source ./bash/nginx/common.bash

set +u
APP=${1}
set -u

ensure_variable_app_is_not_empty

cd ./docker/nginx/

docker-compose --file ${APP}.docker-compose up --detach
