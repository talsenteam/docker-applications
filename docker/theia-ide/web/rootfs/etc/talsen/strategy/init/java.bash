#!/bin/bash

set -euo pipefail

source /etc/talsen/util/indicator/workspace-template.bash

ASSET_TEMPLATE=/etc/talsen/assets/java-template

mvn archetype:generate -DgroupId=team.talsen.kata \
                       -DartifactId=new \
                       -DarchetypeArtifactId=maven-archetype-quickstart \
                       -DinteractiveMode=false

mv new/* .
rm --force --recursive new/

rsync --archive            \
        ${ASSET_TEMPLATE}/ \
        .

mvn test

source /etc/talsen/strategy/init/common/git.bash
source /etc/talsen/strategy/init/common/success-message.bash
