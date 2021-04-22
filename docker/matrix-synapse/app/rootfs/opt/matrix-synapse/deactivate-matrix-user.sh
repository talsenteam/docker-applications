#!/bin/bash

set -euo pipefail

echo "Please enter the user name of an admin user:";
read VAR_NAME_OF_ADMIN_USER
echo "Please enter password for matrix-synapse user '${VAR_NAME_OF_ADMIN_USER}':";
read -s VAR_PASSWORD_OF_ADMIN_USER
echo "Please enter the user name you'd like to deactivate (e.g. john.doe):";
read VAR_NAME_OF_USER_TO_DEACTIVATE

if ! [[ "${VAR_NAME_OF_USER_TO_DEACTIVATE}" =~ ^[0-9a-zA-Z.]+$ ]]; then
  echo >&2 "Error: Provided user name '${VAR_NAME_OF_USER_TO_DEACTIVATE}' contains invalid characters."
  exit 1
fi

VAR_FULLY_QUALIFIED_NAME_OF_USER_TO_DEACTIVATE="@${VAR_NAME_OF_USER_TO_DEACTIVATE}:${SERVER_NAME}"

for VAR_TOKEN in $( cd /data &&  sqlite3 homeserver.db "SELECT token from access_tokens WHERE user_id LIKE '${VAR_FULLY_QUALIFIED_NAME_OF_USER_TO_DEACTIVATE}';" )
do
    /bin/bash /opt/matrix-synapse/leave-all-rooms.sh ${VAR_TOKEN}
done

echo "Deactivating user '${VAR_FULLY_QUALIFIED_NAME_OF_USER_TO_DEACTIVATE}' ..."

VAR_RESPONSE_AS_JSON=`curl -s --insecure -XPOST -d '{"type":"m.login.password", "user":"'${VAR_NAME_OF_ADMIN_USER}'", "password":"'${VAR_PASSWORD_OF_ADMIN_USER}'"}' "https://localhost:8448/_matrix/client/r0/login"`
VAR_ADMIN_ACCESS_TOKEN=`echo "${VAR_RESPONSE_AS_JSON}" | jq -r ".access_token"`

curl --insecure -XPOST -H "Authorization: Bearer ${VAR_ADMIN_ACCESS_TOKEN}" -H "Content-Type: application/json" -d \
'{}' "https://localhost:8448/_matrix/client/r0/admin/deactivate/${VAR_FULLY_QUALIFIED_NAME_OF_USER_TO_DEACTIVATE}"

echo "Deactivating user '${VAR_FULLY_QUALIFIED_NAME_OF_USER_TO_DEACTIVATE}' ... done"
