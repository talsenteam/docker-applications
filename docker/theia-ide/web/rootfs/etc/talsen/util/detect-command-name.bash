#!/bin/bash

set -euo pipefail

# usage: detect_command_name ${0}
function detect_command_name() {
    echo $( sed "s/.bash//g" <<< $( basename ${1} ) )
}
