#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

cd ./docker/kimai/

docker-compose --file default.docker-compose exec proxy /bin/bash /opt/server--nginx-certbot/command-update-configuration.sh proxy.env
