#!/bin/bash

set -euo pipefail

/bin/bash ./bash/nginx/wipe-volumes.bash
/bin/bash ./bash/nextcloud/wipe-volumes.bash
