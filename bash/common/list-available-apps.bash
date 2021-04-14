#!/bin/bash

function list_available_apps() {
  for X in $( find ./docker -mindepth 1 -maxdepth 1 -type d -printf "%P " )
  do
    echo "${X}"
  done
}
