#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

source /etc/talsen/util/detect-command-name.bash
source /etc/talsen/util/detect-help-flag.bash
source /etc/talsen/util/print-help-flag-text.bash

SCRIPT_NAME=$( detect_command_name ${0} )
WORKSPACE_NAME_SUFFIX=$( date +%F )

function print_help() {
    echo "Usage: dojoctl ${SCRIPT_NAME} <md-file>"
    echo "  <md-file>: Markdown file for which the Table of Contents (TOC)"
    echo "             should be updated. The file will be modified directly."
    print_help_flag_text
    echo "--> Updates the TOC of a MD file."
}

if [[ ${#} = 0 ]] || [[ $( detect_help_flag ${@:1} ) = 1 ]];
then
    print_help

    exit 0
fi

MARKDOWN_FILE="${1}"
MARKDOWN_FILE_ABSOLUTE="$( pwd )/${MARKDOWN_FILE}"

if [ ! -f "${MARKDOWN_FILE}" ] ;
then
    echo "Error: File \"${MARKDOWN_FILE}\" at \"${MARKDOWN_FILE_ABSOLUTE}\" does not exist."

    exit 1
fi

MARKDOWN_FILE_ABSOLUTE="$( realpath "${MARKDOWN_FILE}" )"

COMMAND="doctoc ${MARKDOWN_FILE_ABSOLUTE}"

echo "--> Updating TOC:"
echo "--@ ${COMMAND}"
${COMMAND}
