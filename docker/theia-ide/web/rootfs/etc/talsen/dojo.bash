#!/bin/bash

set -euo pipefail

function print_help() {
    local COMMAND_DIR=/etc/talsen/command

    for COMMAND in $( cd ${COMMAND_DIR} && ls *.bash )
    do
        /bin/bash ${COMMAND_DIR}/${COMMAND} --help

        echo ""
    done
}

function invoke_command() {
    local COMMAND_SCRIPT=/etc/talsen/command/${1}.bash

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
