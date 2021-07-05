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
    echo "  <md-file>: Markdown file which should be converted to a static HTML page,"
    echo "             the generated static HTML directory will be"
    echo "             alongside the processed markdown file."
    print_help_flag_text
    echo "--> Converts a MD file to a static HTML page."
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

mkdir --parents "${STATIC_HTML_DIRECTORY}"

cd "${STATIC_HTML_DIRECTORY}"

COMMAND="reveal-md --disable-auto-open --preprocessor /etc/talsen/reveal-md/preproc.js --static ${STATIC_HTML_DIRECTORY} ${MARKDOWN_FILE_ABSOLUTE}"

echo "--> Converting MD to static HTML:"
echo "--@ ${COMMAND}"
${COMMAND}
echo "--> ${STATIC_HTML_INDEX}"
