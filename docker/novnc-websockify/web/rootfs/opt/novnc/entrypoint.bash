#!/bin/bash

set -euo pipefail

LAUNCH_ARGS=""

set +u
if [ "${VNC_CERT}" != "" ] ;
then
  LAUNCH_ARGS="${LAUNCH_ARGS}--cert ${VNC_CERT} "
fi
if [ "${VNC_KEY}" != "" ] ;
then
  LAUNCH_ARGS="${LAUNCH_ARGS}--key ${VNC_KEY} "
fi
if [ "${SSL_ONLY}" = "1" ] || [ "${SSL_ONLY,,}" = "true" ];
then
  LAUNCH_ARGS="${LAUNCH_ARGS}--ssl-only "
fi
if [ "${WEB_PORT}" != "" ] ;
then
  LAUNCH_ARGS="${LAUNCH_ARGS}--listen ${WEB_PORT} "
fi
if [ "${VNC_HOST}" != "" ] && [ "${VNC_PORT}" != "" ] ;
then
  LAUNCH_ARGS="${LAUNCH_ARGS}--vnc ${VNC_HOST}:${VNC_PORT} "
fi
set -u

./utils/websockify/run --help

echo "info: Launch args are: ${LAUNCH_ARGS}"

bash ./utils/launch.sh ${LAUNCH_ARGS}
