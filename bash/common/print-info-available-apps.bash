#!/bin/bash

source ./bash/common/list-available-apps.bash

function print_info_available_apps() {
  echo "info: the following apps are available"

  for X in $( list_available_apps )
  do
    echo "        ${X}"
  done
}
