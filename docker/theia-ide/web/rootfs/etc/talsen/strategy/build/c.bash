#!/bin/bash

set -euo pipefail

BUILD_DIR=build
CCCC_DIR=${BUILD_DIR}/artifacts/cccc
CCCC_REPORT=${CCCC_DIR}/cccc.html
COVERAGE_DIR=${BUILD_DIR}/artifacts/gcov
COVERAGE_REPORT=${COVERAGE_DIR}/GcovCoverageResults.html

if [ ! -f project.yml ];
then
    echo "Cannot build, there is no Ceedling project to build ..."
    exit 1
fi

set +e

ceedling gcov:all utils:gcov

mkdir --parents \
${CCCC_DIR}

cccc src/*.c src/*.h --outdir=${CCCC_DIR} &> /dev/null

set -e

echo ""

if [ -f "${CCCC_REPORT}" ];
then
    echo "--> To view the CCCC Report open \"${CCCC_REPORT}\" in preview mode."
fi

if [ -f "${COVERAGE_REPORT}" ];
then
    echo "--> To view the Coverage Report open \"${COVERAGE_REPORT}\" in preview mode."
fi
