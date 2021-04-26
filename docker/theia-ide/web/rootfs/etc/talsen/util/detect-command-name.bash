#!/bin/bash

set -euo pipefail

function detect_command_name() {
    echo $( sed "s/.bash//g" <<< $( basename ${1} ) )
}
