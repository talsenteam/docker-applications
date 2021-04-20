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
    echo "Usage: dojo ${SCRIPT_NAME} <focus>"
    echo "  <focus>: The focus to set, supported foci are:"

    FOCI=""
    for FOCUS in $( find /etc/talsen/focus/ -maxdepth 1 -name *.foci -type f -printf '%f ' | xargs echo )
    do
        FOCI="${FOCI}${FOCUS} "
    done

    for FOCUS in ${FOCI}
    do
        FOCI_FOR=""
        while IFS= read -r FOCUS_FOR
        do
            FOCI_FOR="${FOCI_FOR}${FOCUS_FOR} "
        done <<< $( cat /etc/talsen/focus/${FOCUS} )
        echo "           ${FOCUS/.foci/}: ${FOCI_FOR}"
    done

    print_help_flag_text
    echo "--> Sets a new focus for the workspace."
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

DESIRED_FOCUS=${1}

IS_FOCUS_SUPPORTED="false"
while IFS= read -r CURRENT_FOCUS
do
    if [ "${DESIRED_FOCUS}" = "${CURRENT_FOCUS}" ];
    then
        IS_FOCUS_SUPPORTED="true"
    fi
done <<< $( cat ${FOCI_LIST} )

if [ "${IS_FOCUS_SUPPORTED}" = "false" ];
then
    echo "Error: The focus \"${DESIRED_FOCUS}\" for workspaces based on a \"${WORKSPACE_TEMPLATE_TYPE}\" template is not supported."

    exit 1
fi

OLD_FOCUS=$( cat ${WORKSPACE_BUILD_FOCUS_INDICATOR} )

if [ "${OLD_FOCUS}" = "${DESIRED_FOCUS}" ];
then
    echo "--> Workspace focus is already \"${DESIRED_FOCUS}\"."
else
    echo ${DESIRED_FOCUS} > ${WORKSPACE_BUILD_FOCUS_INDICATOR}

    echo "--> Workspace focus has been changed from \"${OLD_FOCUS}\" to \"${DESIRED_FOCUS}\"."
fi

CLEAN_SCRIPT=/etc/talsen/strategy/clean/${WORKSPACE_TEMPLATE_TYPE}.bash

if [ -f ${CLEAN_SCRIPT} ];
then
    source ${CLEAN_SCRIPT}
fi
