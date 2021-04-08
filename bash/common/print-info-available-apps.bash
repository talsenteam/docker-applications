#!/bin/bash

function print_info_available_apps() {
  echo "info: the following apps are available"

  for X in $( find ./docker -mindepth 1 -maxdepth 1 -type d -printf "%P " )
  do
    echo "        ${X}"
  done
}
