#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

source /etc/talsen/config/presentation-url.bash
source /etc/talsen/util/detect-command-name.bash
source /etc/talsen/util/detect-help-flag.bash
source /etc/talsen/util/print-help-flag-text.bash

SCRIPT_NAME=$( detect_command_name ${0} )
WORKSPACE_NAME_SUFFIX=$( date +%F )

function print_help() {
    echo "Usage: dojoctl ${SCRIPT_NAME} <md-file>"
    echo "  <md-file>: Markdown file which should be converted to a HTML page,"
    echo "             the generated HTML directory will be hosted under:"
    echo "               ${PRESENTATION_URL}"
    print_help_flag_text
    echo "--> Converts a MD file to a HTML page."
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
STATIC_HTML_DIRECTORY="${MARKDOWN_FILE_ABSOLUTE%.*}.html"
STATIC_HTML_INDEX="${STATIC_HTML_DIRECTORY}/index.html"

COMMAND="reveal-md --disable-auto-open --preprocessor /etc/talsen/reveal-md/preproc.js ${MARKDOWN_FILE} -w"

echo "--> Converting MD to HTML:"
echo "--> Click on the link below, to open the generated presentation."
echo "-->   ${PRESENTATION_URL}/${MARKDOWN_FILE}"
echo ""
echo "--@ ${COMMAND}"
${COMMAND}
