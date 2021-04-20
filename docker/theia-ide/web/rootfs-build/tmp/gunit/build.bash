#!/bin/bash

set -euo pipefail

cd $( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )

rm --force     \
   --recursive \
   build/      \
   include/    \
   src/

mkdir --parents \
      include/  \
      src/

rsync --archive           \
      googlemock/include/ \
      include/

rsync --archive           \
      googletest/include/ \
      include/

rsync --archive       \
      googlemock/src/ \
      src/

rsync --archive       \
      googletest/src/ \
      src/

meson build

cd build/

set +e

ninja

set -e

cd ..
