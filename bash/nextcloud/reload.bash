#!/bin/bash

set -euo pipefail

cd ./docker/nextcloud/

docker-compose --file default.docker-compose exec proxy /bin/bash /opt/server--nginx-certbot/command-update-configuration.sh proxy.env
