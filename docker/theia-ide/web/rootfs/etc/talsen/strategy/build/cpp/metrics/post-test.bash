#!/bin/bash

set -euo pipefail

BUILD_DIR=.build
CCCC_DIR=.cccc
CCCC_REPORT=${CCCC_DIR}/cccc.html
COVERAGE_DIR=.coverage
COVERAGE_FILE=${BUILD_DIR}/meson-logs/coverage.info
COVERAGE_REPORT=${COVERAGE_DIR}/index.html
PROJECT_DIR=$( pwd )
SOURCE_DIR=src
TEMP_COVERAGE_DIR=${BUILD_DIR}/meson-logs/coveragereport
TEMP_COVERAGE_FILE=${BUILD_DIR}/meson-logs/coverage-temp.info

echo -e "Generating coverage report ..."

GLOBIGNORE="*" # prevent expansion of wildcards link '/usr/include/*' or similar

LCOV_EXLCUDE=""
while IFS= read -r ITEM
do
    LCOV_EXLCUDE="${LCOV_EXLCUDE}'${ITEM}' "
done < .lcovignore

lcov --directory ${BUILD_DIR}            \
     --capture                           \
     --output-file ${TEMP_COVERAGE_FILE} \
     --rc lcov_branch_coverage=1         \
     --no-checksum

echo ""

lcov --remove ${TEMP_COVERAGE_FILE}      \
     $( eval echo -e "${LCOV_EXLCUDE}" ) \
     --output-file ${COVERAGE_FILE}      \
     --rc lcov_branch_coverage=1

echo ""

genhtml --prefix ${BUILD_DIR}                   \
        --output-directory ${TEMP_COVERAGE_DIR} \
        --title 'Code coverage'                 \
        --legend                                \
        --branch-coverage                       \
        --show-details ${COVERAGE_FILE}

rsync --archive             \
      ${TEMP_COVERAGE_DIR}/ \
      ${COVERAGE_DIR}

echo -e "Generating coverage report ... done"

echo -e "Generating \"C and C++ Code Counter\" report ..."

unset GLOBIGNORE

cd ${SOURCE_DIR}

cccc *.cpp --outdir=${PROJECT_DIR}/${BUILD_DIR}/${CCCC_DIR} &> /dev/null

rsync --archive                               \
      ${PROJECT_DIR}/${BUILD_DIR}/${CCCC_DIR} \
      ${PROJECT_DIR}

rm --force --recursive                     \
   ${PROJECT_DIR}/${BUILD_DIR}/${CCCC_DIR}

cd ${PROJECT_DIR}

echo -e "Generating \"C and C++ Code Counter\" report ... done"

echo ""

echo "--> To view the CCCC Report open \"${CCCC_REPORT}\" in preview mode."
echo "--> To view the Coverage Report open \"${COVERAGE_REPORT}\" in preview mode."

