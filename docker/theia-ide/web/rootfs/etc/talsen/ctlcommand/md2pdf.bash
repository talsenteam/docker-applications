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
    echo "  <md-file>: Markdown file which should be converted to a PDF,"
    echo "             the generated PDF will be named like the markdown"
    echo "             and will be placed in the same directory."
    print_help_flag_text
    echo "--> Converts a MD file to a PDF file."
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
MARKDOWN_FILE_PARENT_DIRECTORY="$( dirname "${MARKDOWN_FILE_ABSOLUTE}" )"
PDF_FILE="${MARKDOWN_FILE%.*}.pdf"
PDF_FILE_ABSOLUTE="${MARKDOWN_FILE_ABSOLUTE%.*}.pdf"

cd "${MARKDOWN_FILE_PARENT_DIRECTORY}"

COMMAND="pandoc ${MARKDOWN_FILE} -s -o ${PDF_FILE}"

echo "--> Converting MD to PDF:"
echo "--@ ${COMMAND}"
${COMMAND}
echo "--> ${PDF_FILE_ABSOLUTE}"
