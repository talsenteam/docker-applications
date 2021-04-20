#!/bin/bash

set -euo pipefail

source /etc/talsen/util/indicator/workspace-template.bash

CHEAT_SHEET_TARGET=.cheats
PLANTUML_CHEAT_SHEET_TEMPLATE=/etc/talsen/assets/cheat-sheets/.plantuml

mkdir --parents             \
      ${CHEAT_SHEET_TARGET}

rsync --archive                          \
        ${PLANTUML_CHEAT_SHEET_TEMPLATE} \
        ${CHEAT_SHEET_TARGET}

echo "--> Cheat sheets for \"plantuml\" template have been imported to \"${CHEAT_SHEET_TARGET}\"."
