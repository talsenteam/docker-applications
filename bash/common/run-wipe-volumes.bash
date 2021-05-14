#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

source ./bash/common/formatting.bash
source ./bash/common/print-info-available-apps.bash

function print_error_no_app_specified() {
  echo "info: no app specified, for which the volumes should be wiped"
}

function ensure_variable_app_is_not_empty() {
  if [ "${APP}" = "" ] ;
  then
    print_error_no_app_specified
    print_info_available_apps
    exit 1
  fi
}

function wipe_volumes() {
  echo "info: Wiping local volumes ..."

  set +u
  local APP=${1}
  set -u

  if [ "${APP}" = "" ] ;
  then
    ensure_variable_app_is_not_empty
    exit 1
  fi

  source ./docker/${APP}/.env

  local VAR_ARE_THERE_ANY_VOLUMES="false"
  local IS_HOST_PATH_TO_VOLUMES_ROOT_UNSET="false"

  set +u
  if [ "${HOST_PATH_TO_VOLUMES_ROOT}" = "" ] ;
  then
    IS_HOST_PATH_TO_VOLUMES_ROOT_UNSET="true"
  fi
  set -u

  if [ "${IS_HOST_PATH_TO_VOLUMES_ROOT_UNSET}" = "false" ] && [ -d "./docker/${APP}/${HOST_PATH_TO_VOLUMES_ROOT}" ] ;
  then
    local DIR_TO_WIPE="$( realpath ./docker/${APP}/${HOST_PATH_TO_VOLUMES_ROOT} )"

    if [ -d ${DIR_TO_WIPE} ];
    then
        for VAR_NAME_OF_VOLUME in $( ls --almost-all ${DIR_TO_WIPE}/ )
        do
            local VAR_PATH_TO_VOLUME=${DIR_TO_WIPE}/${VAR_NAME_OF_VOLUME}/
            if [ ! -d ${VAR_PATH_TO_VOLUME} ];
            then
                continue
            fi

            echo -E "info: * wiping '${VAR_NAME_OF_VOLUME}' ..."

            rm --recursive           \
                --force               \
                ${VAR_PATH_TO_VOLUME}

            echo -e "info: * wiping '${VAR_NAME_OF_VOLUME}' ... $( __done )"

            VAR_ARE_THERE_ANY_VOLUMES="true"
        done
    fi
  fi

  if [ ${VAR_ARE_THERE_ANY_VOLUMES} = "false" ];
  then
      echo -e "info: Wiping local volumes ... $( __skipped )"
  else
      echo -e "info: Wiping local volumes ... $( __done )"
  fi
}

function run_wipe_volumes() {
  set +u
  local APP=${1}
  set -u

  wipe_volumes ${APP}
}

run_wipe_volumes ${@}
