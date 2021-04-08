#!/bin/bash

function print_error_no_app_specified() {
  echo "error: no app specified, for which the proxy should run"
}

function print_info_available_apps() {
  echo "info: the following apps are available"

  for X in $( find ./docker -mindepth 1 -maxdepth 1 -type d -printf "%P " )
  do
    if [ "${X}" = "nginx" ] ;
    then
      continue
    fi

    echo "        ${X}"
  done
}

function ensure_variable_app_is_not_empty() {
  if [ "${APP}" = "" ] ;
  then
    print_error_no_app_specified
    print_info_available_apps
    exit 1
  fi
}
