#!/bin/bash

source ./bash/common/print-info-available-apps.bash

function print_error_no_app_specified() {
  echo "error: no app specified, for which the proxy should run"
}

function print_info_available_apps_except_nginx() {
  print_info_available_apps | \
  while IFS= read -r X
  do
    if [ "${X}" = "        nginx" ] ;
    then
      continue
    fi

    echo "${X}"
  done
}

function ensure_variable_app_is_not_empty() {
  if [ "${APP}" = "" ] ;
  then
    print_error_no_app_specified
    print_info_available_apps_except_nginx
    exit 1
  fi
}
