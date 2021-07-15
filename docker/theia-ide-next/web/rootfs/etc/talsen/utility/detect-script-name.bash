#!/bin/bash

function detect_script_name() {
    echo $( sed "s/.bash//g" <<< $( basename ${1} ) )
}
