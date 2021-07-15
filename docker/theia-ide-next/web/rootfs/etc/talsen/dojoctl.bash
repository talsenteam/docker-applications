#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

COMMAND_DIR=/etc/talsen/command/dojoctl

function print_help() {
    for COMMAND in $( cd ${COMMAND_DIR} && ls *.bash )
    do
        /bin/bash ${COMMAND_DIR}/${COMMAND} --help

        echo ""
    done
}

function invoke_command() {
    local COMMAND_SCRIPT=${COMMAND_DIR}/${1}.bash

    if [ ! -f ${COMMAND_SCRIPT} ];
    then
        echo "Error: unknown command \"${1}\""

        exit 1
    fi

    /bin/bash ${COMMAND_SCRIPT} ${@:2}
}

if [ ${#} = 0 ];
then
    print_help

    exit 0
fi

invoke_command ${@:1}
