#!/bin/bash

function detect_help_flag() {
    if [ ${#} = 0 ];
    then
        echo 0
    elif [ "${1}" = "--help" ];
    then
        echo 1
    else
        echo 0
    fi
}
