#!/bin/bash

set -euo pipefail

function generate() {
  echo " * Generating turn server configuration"
  if [ -f "/data/turnserver.conf" ];
  then
    echo "   ...skipped."
  else
    cp --force                    \
       /templates/turnserver.conf \
       /data/turnserver.conf
    echo "   ...done."
  fi
}

function start() {
  if [ ! -f "/data/turnserver.conf" ];
  then
    echo "Turn server configuration missing."
    generate
  fi

  echo " * Importing turn server configuration"
  cp --force               \
     /data/turnserver.conf \
     /etc/turnserver.conf
  echo "   ...done."

  echo " * Starting turn server"
  turnserver & \
  VAR_PID_COTURN=${!}
  echo "   ...done."

  trap 'set -euo pipefail;                                                                  \
          kill -TERM ${VAR_PID_COTURN};                                                  \
          exit 0'                                                                             \
        SIGTERM

  wait ${VAR_PID_COTURN}
}

VAR_OPTION="${1}"

case ${VAR_OPTION} in
  "version")
    dpkg -s coturn | grep "Version: "
    ;;

  "generate")
    generate
    ;;
  
  "start")
    start
    ;;
esac