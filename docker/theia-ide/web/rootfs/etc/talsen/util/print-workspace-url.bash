#!/bin/bash

function print_workspace_url() {
  local WORKSPACE_NAME=${1}

  source /etc/talsen/config/workspace-base-url.dojo.bash
  WORKSPACE_URL_DOJO=${WORKSPACE_BASE_URL}${WORKSPACE_NAME}

  source /etc/talsen/config/workspace-base-url.editor.bash
  WORKSPACE_URL_EDITOR=${WORKSPACE_BASE_URL}${WORKSPACE_NAME}

  echo "--> The workspace dojo is located at:"
  echo "      ${WORKSPACE_URL_DOJO}"
  echo "--> The workspace editor is located at:"
  echo "      ${WORKSPACE_URL_EDITOR}"
}
