#!/bin/bash

set -euo pipefail

source /etc/talsen/util/detect-command-name.bash
source /etc/talsen/util/detect-help-flag.bash
source /etc/talsen/util/print-help-flag-text.bash

source /etc/talsen/util/indicator/workspace.bash
source /etc/talsen/util/indicator/workspace-name.bash
source /etc/talsen/util/indicator/workspace-template.bash

PWD=$( pwd )
SCRIPT_NAME=$( detect_command_name ${0} )

TEMPLATES=""
for TEMPLATE in $( find /etc/talsen/assets/ -maxdepth 1 -name *-template -type d -printf '%f ' | xargs echo )
do
    TEMPLATE="${TEMPLATE/-template/}"
    TEMPLATES="'${TEMPLATE}', ${TEMPLATES}"
done
TEMPLATES="${TEMPLATES::-2}"

function print_help() {
    echo "Usage: dojo ${SCRIPT_NAME} <template>"
    echo "  <template>: Type of template to use, supported templates are:"
    echo "              ${TEMPLATES}"
    print_help_flag_text
    echo "--> Initializes an empty workspace with a specific template."
}

if [[ ${#} = 0 ]] || [[ $( detect_help_flag ${@:1} ) = 1 ]];
then
    print_help

    exit 0
fi

if [ ! -d ${WORKSPACE_INDICATOR} ];
then
    echo "Error: \"${PWD}\" is not a workspace directory."

    exit 1
elif [ -f ${WORKSPACE_TEMPLATE_INDICATOR} ];
then
    echo "Error: Workspace \"$( cat ${WORKSPACE_NAME_INDICATOR} )\" is already initialized as \"$( cat ${WORKSPACE_TEMPLATE_INDICATOR} )\" workspace."

    exit 1
fi

TEMPLATE_TYPE=${1}

ASSET_X_TEMPLATE=/etc/talsen/assets/${TEMPLATE_TYPE}-template

if [ ! -d ${ASSET_X_TEMPLATE} ];
then
    echo "Error: Template \"${TEMPLATE_TYPE}\" is not known."

    exit 1
fi

STRATEGY_SCRIPT=/etc/talsen/strategy/${SCRIPT_NAME}/${TEMPLATE_TYPE}.bash

source ${STRATEGY_SCRIPT}
