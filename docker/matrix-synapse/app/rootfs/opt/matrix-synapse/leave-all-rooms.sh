#!/bin/bash

set -euo pipefail

VAR_TOKEN_OF_USER_TO_DISJOIN=${1}

echo "Leaving all rooms ..."

if [ -z "${VAR_TOKEN_OF_USER_TO_DISJOIN}" ];
then
    echo "No user token was provided."
    echo "Leaving all rooms ... skipped"
    exit 0
fi

VAR_ROOMS_TO_DISJOIN_FROM="$( curl -s "http://localhost:8008/_matrix/client/r0/joined_rooms?access_token=${VAR_TOKEN_OF_USER_TO_DISJOIN}" | jq -r '.joined_rooms[]' )"

if [ -z "${VAR_ROOMS_TO_DISJOIN_FROM}" ];
then
    echo "Token ${VAR_TOKEN_OF_USER_TO_DISJOIN} has no rooms to leave."
    echo "Leaving all rooms ... skipped"
    exit 0
fi

echo "${VAR_TOKEN_OF_USER_TO_DISJOIN} is leaving all rooms ..."

echo "${VAR_ROOMS_TO_DISJOIN_FROM}" | while read -r VAR_ROOM_TO_DISJOIN_FROM
do
    echo " * leaving room \"${VAR_ROOM_TO_DISJOIN_FROM}\" ..."
    curl -s -o /dev/null -X POST \
        "http://localhost:8008/_matrix/client/r0/rooms/${VAR_ROOM_TO_DISJOIN_FROM}/leave?access_token=${VAR_TOKEN_OF_USER_TO_DISJOIN}"
    echo " * leaving room \"${VAR_ROOM_TO_DISJOIN_FROM}\" ... done"
    sleep 1
done

echo "${VAR_TOKEN_OF_USER_TO_DISJOIN} is leaving all rooms ... done"

echo "Leaving all rooms ... done"
