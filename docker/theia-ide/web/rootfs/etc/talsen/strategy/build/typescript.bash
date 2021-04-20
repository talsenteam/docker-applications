#!/bin/bash

set -euo pipefail

if [ ! -f package.json ];
then
    echo "Cannot build, there is no package.json ..."
    exit 1
fi

yarn

set +e

yarn test

set -e
