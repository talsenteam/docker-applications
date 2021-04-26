#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

source /etc/talsen/util/detect-command-name.bash
source /etc/talsen/util/detect-help-flag.bash
source /etc/talsen/util/print-help-flag-text.bash

source /etc/talsen/util/indicator/workspace.bash

SCRIPT_NAME=$( detect_command_name ${0} )

function print_help() {
    echo "Usage: dojo ${SCRIPT_NAME}"
    print_help_flag_text
    echo "--> Prints the workspace history."
}

if [[ $( detect_help_flag ${@:1} ) = 1 ]];
then
    print_help

    exit 0
fi

if [ ! -d ${WORKSPACE_INDICATOR} ];
then
    echo "Error: \"${PWD}\" is not a workspace directory."

    exit 1
fi

COMMAND="git log --oneline"

echo "--> The workspace history is:"
echo "--@ ${COMMAND}"
${COMMAND}
