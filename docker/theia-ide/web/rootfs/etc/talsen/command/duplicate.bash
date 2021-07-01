#!/bin/bash

set -euo pipefail

source /etc/talsen/util/detect-command-name.bash
source /etc/talsen/util/detect-help-flag.bash
source /etc/talsen/util/print-help-flag-text.bash

source /etc/talsen/util/indicator/workspace.bash
source /etc/talsen/util/indicator/workspace-name.bash
source /etc/talsen/util/indicator/workspace-template.bash

source /etc/talsen/config/workspace-base-url.editor.bash

SCRIPT_NAME=$( detect_command_name ${0} )

function print_help() {
    echo "Usage: dojo ${SCRIPT_NAME} <name>"
    echo "  <name>: Will be appended to the duplicated workspace,"
    echo "          the duplicated workspace name looks like the following:"
    echo "          \"current-workspace-<name>\""
    print_help_flag_text
    echo "--> ${SCRIPT_NAME^}s an initialized workspace."
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

WORKSPACE_DIR=$( realpath . )
WORKSPACE_NAME=$( basename ${WORKSPACE_DIR} )
NEW_WORKSPACE_NAME=${WORKSPACE_NAME}-${1}
NEW_WORKSPACE_DIR=/home/project/${NEW_WORKSPACE_NAME}
NEW_WORKSPACE_URL=${WORKSPACE_BASE_URL}${NEW_WORKSPACE_DIR}

if [ -d ${NEW_WORKSPACE_DIR} ];
then
    echo "Error: Another workspace at \"${NEW_WORKSPACE_URL}\" already exists."

    exit 1
elif [[ ! ${NEW_WORKSPACE_NAME} =~ ^[-_0-9a-zA-Z]+$ ]]
then
    echo "Error: The workspace name \"${NEW_WORKSPACE_NAME}\" is invalid."

    exit 1
fi

echo "--> Duplicating workspace."
rsync --archive . ${NEW_WORKSPACE_DIR}

cd ${NEW_WORKSPACE_DIR}

echo ${NEW_WORKSPACE_NAME} > ${WORKSPACE_NAME_INDICATOR}

dojo clean
dojo url

cd ${WORKSPACE_DIR}
