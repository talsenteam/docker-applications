#!/bin/bash

set -euo pipefail

source /etc/talsen/util/indicator/workspace.bash
source /etc/talsen/util/indicator/workspace-build-focus.bash
source /etc/talsen/util/indicator/workspace-gunit-lib.bash
source /etc/talsen/util/indicator/workspace-gunit-meson-build.bash
source /etc/talsen/util/indicator/workspace-meson-options.bash
source /etc/talsen/util/indicator/workspace-cpp-flags-default.bash

BUILD_DIR=.build
BUILD_FOCUS=$( cat ${WORKSPACE_BUILD_FOCUS_INDICATOR} )
PROJECT_DIR=$( pwd )
TARGET_NAME=run-workspace

source /etc/talsen/util/indicator/workspace-cpp-flags-${BUILD_FOCUS}.bash

SOURCES=""
for SOURCE in $( find . -path ./${WORKSPACE_INDICATOR} -prune -o -name *.cpp -printf '%P ' | xargs echo )
do
    SOURCES="'${SOURCE}', ${SOURCES}"
done
if (( ${#SOURCES} > 1 ));
then
    SOURCES="${SOURCES::-2}"
fi

echo "" > meson.build
while IFS= read -r LINE
do
    if [ "${LINE}" = "# sources" ];
    then
        echo "${SOURCES}" >> meson.build
    else
        echo "${LINE}" >> meson.build
    fi
done <<< $( cat ${WORKSPACE_GUNIT_MESON_BUILD_INDICATOR} )

if [ ! -d ${BUILD_DIR} ];
then
    CPP_FLAGS_DEFAULT=""
    for FLAG in $( cat ${WORKSPACE_CPP_FLAGS_DEFAULT_INDICATOR} )
    do
        CPP_FLAGS_DEFAULT="'${FLAG}', ${CPP_FLAGS_DEFAULT}"
    done
    if (( ${#CPP_FLAGS_DEFAULT} > 1 ));
    then
        CPP_FLAGS_DEFAULT="${CPP_FLAGS_DEFAULT::-2}"
    fi

    CPP_FLAGS_FOCUS=""
    for FLAG in $( cat ${WORKSPACE_CPP_FLAGS_FOCUS_INDICATOR} )
    do
        CPP_FLAGS_FOCUS="'${FLAG}', ${CPP_FLAGS_FOCUS}"
    done
    if (( ${#CPP_FLAGS_FOCUS} > 1 ));
    then
        CPP_FLAGS_FOCUS="${CPP_FLAGS_FOCUS::-2}"
    fi

    cat ${WORKSPACE_MESON_OPTIONS_INDICATOR} \
    > meson_options.txt
    echo "option( 'exe_name', type : 'string', value : '${TARGET_NAME}' )" \
    >> meson_options.txt
    echo "option( 'gunit_lib_dir', type : 'string', value : '$( pwd )/${WORKSPACE_GUNIT_LIB_INDICATOR}' )" \
    >> meson_options.txt
    echo "option( 'x_cpp_flags_default', type : 'array', value : [ ${CPP_FLAGS_DEFAULT} ] )" \
    >> meson_options.txt
    echo "option( 'x_cpp_flags_focus', type : 'array', value : [ ${CPP_FLAGS_FOCUS} ] )" \
    >> meson_options.txt

    meson ${BUILD_DIR}
fi

cd ${BUILD_DIR}

echo ""

ninja

echo ""

./${TARGET_NAME}

POST_TEST_SCRIPT=/etc/talsen/strategy/build/cpp/${BUILD_FOCUS}/post-test.bash

if [ -f ${POST_TEST_SCRIPT} ];
then
    cd ${PROJECT_DIR}

    echo ""

    source ${POST_TEST_SCRIPT}

    cd ${BUILD_DIR}
fi

cd ${PROJECT_DIR}
