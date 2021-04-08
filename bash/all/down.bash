#!/bin/bash

set -euo pipefail

/bin/bash ./bash/nginx/down.bash
/bin/bash ./bash/nextcloud/down.bash
