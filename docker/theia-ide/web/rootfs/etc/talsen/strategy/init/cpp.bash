#!/bin/bash

set -euo pipefail

source /etc/talsen/util/indicator/workspace-gunit-src.bash
source /etc/talsen/util/indicator/workspace-template.bash

ASSET_TEMPLATE=/etc/talsen/assets/cpp-template

rsync --archive            \
        ${ASSET_TEMPLATE}/ \
        .

rsync --archive                        \
      ${WORKSPACE_GUNIT_SRC_INDICATOR} \
      .

source /etc/talsen/strategy/init/common/git.bash
source /etc/talsen/strategy/init/common/success-message.bash
