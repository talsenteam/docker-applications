#!/bin/bash

set -euo pipefail

OVERRIDE_MARKER="/.is-overridden"

IS_OVERRIDDEN="false"
if [ -f "${OVERRIDE_MARKER}" ] ;
then
  IS_OVERRIDDEN="true"
fi

function export_default() {
  local DEFAULT_DIR="/default"
  local UVNC_CFG_DIR="/etc/uvnc/"

  if [ "${IS_OVERRIDDEN}" = "false" ] ;
  then
    mkdir --parents "${DEFAULT_DIR}${UVNC_CFG_DIR}"
    rsync --archive "${UVNC_CFG_DIR}" "${DEFAULT_DIR}${UVNC_CFG_DIR}"
  fi
}

function import_override() {
  local OVERRIDE_DIR="/override"

  mkdir --parents "${OVERRIDE_DIR}"
  rsync --archive "${OVERRIDE_DIR}/" "/"

  touch "${OVERRIDE_MARKER}"
}

function start_uvnc_repeater() {
  echo " * Starting uvnc-repeater ..."
  ${UVNCREPSVC} ${UVNCREPINI} 2>> ${UVNCREPLOG} & VAR_PID_UVNC=${!}
  echo " * Starting uvnc-repeater ... done"
}

function stop_uvnc_repeater() {
  echo " * Stopping uvnc-repeater ..."
  kill -TERM ${VAR_PID_UVNC}
  echo " * Stopping uvnc-repeater ... done"
}

function handle_termination_signal() {
  echo " * Caugth for termination signal ..."
  stop_uvnc_repeater
  sleep 2
  exit 0
}

UVNCREPLOG=/var/log/uvncrepeater.log
UVNCREPSVC=/usr/sbin/uvncrepeatersvc
UVNCREPINI=/etc/uvnc/uvncrepeater.ini

export_default
import_override

start_uvnc_repeater

echo " * Waiting for termination signal ..."
trap handle_termination_signal SIGTERM

wait ${VAR_PID_UVNC}
