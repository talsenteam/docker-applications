#!/bin/bash

set -euo pipefail

source /etc/talsen/util/detect-command-name.bash
source /etc/talsen/util/detect-help-flag.bash
source /etc/talsen/util/print-help-flag-text.bash

source /etc/talsen/util/indicator/workspace-build-focus.bash
source /etc/talsen/util/indicator/workspace.bash
source /etc/talsen/util/indicator/workspace-name.bash
source /etc/talsen/util/indicator/workspace-template.bash

SCRIPT_NAME=$( detect_command_name ${0} )

function print_help() {
    echo "Usage: dojo ${SCRIPT_NAME}"
    print_help_flag_text
    echo "--> Displays the currently used workspace focus."
}

if [ $( detect_help_flag ${@:1} ) = 1 ];
then
    print_help

    exit 0
fi

if [ ! -d ${WORKSPACE_INDICATOR} ];
then
    echo "Error: \"${PWD}\" is not a workspace directory."

    exit 1
elif [ ! -f ${WORKSPACE_TEMPLATE_INDICATOR} ];
then
    echo "Error: Workspace \"$( cat ${WORKSPACE_NAME_INDICATOR} )\" is not initialized yet."

    exit 1
fi

WORKSPACE_TEMPLATE_TYPE=$( cat ${WORKSPACE_TEMPLATE_INDICATOR} )
FOCI_LIST=/etc/talsen/focus/${WORKSPACE_TEMPLATE_TYPE}.foci

if [ ! -f ${FOCI_LIST} ];
then
    echo "Error: Workspace foci for workspaces based on a \"${WORKSPACE_TEMPLATE_TYPE}\" template are not supported."

    exit 1
fi

CURRENT_FOCUS=$( cat ${WORKSPACE_BUILD_FOCUS_INDICATOR} )

echo "--> Current workspace focus is \"${CURRENT_FOCUS}\"."
