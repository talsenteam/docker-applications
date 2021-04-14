#!/bin/bash

set -euo pipefail

KIMAI_DIR="/opt/kimai"
KIMAI_VAR_DIR="${KIMAI_DIR}/var"

function import_defaults() {
    local \
    DEFAULT_DIR="/default"

    if [ -z "$( ls ${KIMAI_VAR_DIR} )" ];
    then
        sudo \
        rsync \
        --archive \
        "${DEFAULT_DIR}/${KIMAI_VAR_DIR}/" \
        "${KIMAI_VAR_DIR}"
    fi
}

function import_overrides() {
    local \
    OVERRIDE_DIR="/override"
    
    if [ -d "${OVERRIDE_DIR}" ] ;
    then
        sudo \
        chown \
        --recursive \
        www-data:www-data \
        "${OVERRIDE_DIR}"

        sudo \
        rsync \
        --archive \
        "${OVERRIDE_DIR}/" \
        "/"
    fi
}

function clear_kimai_cache() {
    local \
    KIMAI_CACHE_DIR="${KIMAI_VAR_DIR}/cache"

    sudo \
    rm \
    -fr \
    "${KIMAI_CACHE_DIR}"
}

function fix_permissions() {
    sudo \
    chown \
    www-data:www-data \
    "${KIMAI_DIR}"

    sudo \
    chown \
    --recursive \
    www-data:www-data \
    "${KIMAI_VAR_DIR}"
}

function run_entrypoint() {
    import_defaults
    import_overrides
    clear_kimai_cache
    fix_permissions

    /bin/bash \
    /startup.sh
}

run_entrypoint
