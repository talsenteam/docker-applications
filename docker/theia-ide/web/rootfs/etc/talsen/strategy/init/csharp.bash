#!/bin/bash

set -euo pipefail

source /etc/talsen/util/indicator/workspace-template.bash

ASSET_TEMPLATE=/etc/talsen/assets/csharp-template

rsync --archive            \
        ${ASSET_TEMPLATE}/ \
        .

source /etc/talsen/strategy/init/common/git.bash
source /etc/talsen/strategy/init/common/delay.bash
dotnet build > /dev/null
source /etc/talsen/strategy/init/common/success-message.bash
