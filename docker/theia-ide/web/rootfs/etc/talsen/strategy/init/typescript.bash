#!/bin/bash

set -euo pipefail

source /etc/talsen/util/indicator/workspace-template.bash

ASSET_TEMPLATE=/etc/talsen/assets/typescript-template

rsync --archive            \
        ${ASSET_TEMPLATE}/ \
        .

source /etc/talsen/strategy/init/common/git.bash
source /etc/talsen/strategy/init/common/delay.bash
yarn
source /etc/talsen/strategy/init/common/success-message.bash
