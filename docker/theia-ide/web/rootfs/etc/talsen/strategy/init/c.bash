#!/bin/bash

set -euo pipefail

source /etc/talsen/util/indicator/workspace-template.bash

ASSET_TEMPLATE=/etc/talsen/assets/c-template

rsync --archive            \
        ${ASSET_TEMPLATE}/ \
        .

rm src/.gitkeep
rm test/support/.gitkeep

ceedling module:create[dummy] \
> /dev/null

source /etc/talsen/strategy/init/common/git.bash
source /etc/talsen/strategy/init/common/success-message.bash
