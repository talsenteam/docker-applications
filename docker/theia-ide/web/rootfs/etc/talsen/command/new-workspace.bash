#!/bin/bash

set -euo pipefail

source /etc/talsen/util/detect-command-name.bash
source /etc/talsen/util/detect-help-flag.bash
source /etc/talsen/util/print-help-flag-text.bash
source /etc/talsen/util/print-workspace-url.bash

source /etc/talsen/util/indicator/workspace-name.bash

source /etc/talsen/config/workspace-base-url.editor.bash

ASSET_NEW_WORKSPACE=/etc/talsen/assets/new-workspace

SCRIPT_NAME=$( detect_command_name ${0} )
WORKSPACE_NAME_SUFFIX=$( date +%F )

function print_help() {
    echo "Usage: dojo ${SCRIPT_NAME} <name>"
    echo "  <name>: Will have the current date appended, the full name"
    echo "          looks like the following: \"${WORKSPACE_NAME_SUFFIX}-<name>\""
    print_help_flag_text
    echo "--> Creates a new empty dojo workspace."
}

if [[ ${#} = 0 ]] || [[ $( detect_help_flag ${@:1} ) = 1 ]];
then
    print_help

    exit 0
fi

WORKSPACE_NAME=${1}
WORKSPACE_DIR=/home/project/${WORKSPACE_NAME_SUFFIX}-${WORKSPACE_NAME}
WORKSPACE_URL=${WORKSPACE_BASE_URL}${WORKSPACE_NAME_SUFFIX}-${WORKSPACE_NAME}

if [ -d ${WORKSPACE_DIR} ];
then
    echo "Error: Another workspace at \"${WORKSPACE_URL}\" already exists."

    exit 1
elif [[ ! ${WORKSPACE_NAME} =~ ^[-_0-9a-zA-Z]+$ ]]
then
    echo "Error: The workspace name \"${WORKSPACE_NAME}\" is invalid."

    exit 1
fi

cp --archive               \
    ${ASSET_NEW_WORKSPACE} \
    ${WORKSPACE_DIR}

echo ${WORKSPACE_NAME} > ${WORKSPACE_DIR}/${WORKSPACE_NAME_INDICATOR}

echo "--> A new empty workspace has been created."
print_workspace_url ${WORKSPACE_NAME_SUFFIX}-${WORKSPACE_NAME}
