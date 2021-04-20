#!/bin/bash

set -euo pipefail

source /etc/talsen/util/indicator/workspace-template.bash

source /etc/talsen/strategy/cheat/plantuml.bash

CHEAT_SHEET_TARGET=.cheats
GUNIT_CHEAT_SHEET_TEMPLATE=/etc/talsen/assets/cheat-sheets/.gunit

mkdir --parents             \
      ${CHEAT_SHEET_TARGET}

rsync --archive                       \
        ${GUNIT_CHEAT_SHEET_TEMPLATE} \
        ${CHEAT_SHEET_TARGET}

echo "--> Cheat sheets for \"cpp\" template have been imported to \"${CHEAT_SHEET_TARGET}\"."
