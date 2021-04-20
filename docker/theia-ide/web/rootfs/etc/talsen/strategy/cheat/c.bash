#!/bin/bash

set -euo pipefail

source /etc/talsen/util/indicator/workspace-template.bash

source /etc/talsen/strategy/cheat/plantuml.bash

CHEAT_SHEET_TARGET=.cheats
CEEDLING_CHEAT_SHEET_TEMPLATE=/etc/talsen/assets/cheat-sheets/.ceedling

mkdir --parents             \
      ${CHEAT_SHEET_TARGET}

rsync --archive                          \
        ${CEEDLING_CHEAT_SHEET_TEMPLATE} \
        ${CHEAT_SHEET_TARGET}

echo "--> Cheat sheets for \"c\" template have been imported to \"${CHEAT_SHEET_TARGET}\"."
