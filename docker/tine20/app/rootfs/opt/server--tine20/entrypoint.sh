#!/bin/bash

set -euo pipefail

function keep_timezone_information_up_to_date() {
    echo " * Updating timezone data ..."
    dpkg-reconfigure tzdata
    echo " * Updating timezone data ... done"
}

function check_system_environment() {
    echo " * Checking system environment ..."
    if [ -z "${DB_LOCATION}" ];
    then
        echo >&2 "Environment variable named is DB_LOCATION missing."
        exit 1
    fi
    if [ -z "${DB_NAME}" ];
    then
        echo >&2 "Environment variable named is DB_NAME missing."
        exit 1
    fi
    if [ -z "${DB_USERNAME}" ];
    then
        echo >&2 "Environment variable named is DB_USERNAME missing."
        exit 1
    fi
    if [ -z "${DB_PASSWORD}" ];
    then
        echo >&2 "Environment variable named is DB_PASSWORD missing."
        exit 1
    fi
    if [ -z "${LOG_LEVEL}" ];
    then
        echo >&2 "Environment variable named is LOG_LEVEL missing."
        exit 1
    fi
    if [ -z "${ADMIN_NAME}" ];
    then
        echo >&2 "Environment variable named is ADMIN_NAME missing."
        exit 1
    fi
    if [ -z "${ADMIN_PASS}" ];
    then
        echo >&2 "Environment variable named is ADMIN_PASS missing."
        exit 1
    fi
    if [ -z "${SETUP_NAME}" ];
    then
        echo >&2 "Environment variable named is SETUP_NAME missing."
        exit 1
    fi
    if [ -z "${SETUP_PASS}" ];
    then
        echo >&2 "Environment variable named is SETUP_PASS missing."
        exit 1
    fi
    if [ -z "${TIMEZONE}" ];
    then
        echo >&2 "Environment variable named is TIMEZONE missing."
        exit 1
    fi
    if [ -z "${SERVER_SCHEME}" ];
    then
        echo >&2 "Environment variable named is SERVER_SCHEME missing."
        exit 1
    fi
    if [ -z "${SERVER_NAME}" ];
    then
        echo >&2 "Environment variable named is SERVER_NAME missing."
        exit 1
    fi
    echo " * Checking system environment ... done"
}

function check_system_environment_validity() {
    echo " * Checking validity of environment variables ..."
    if ! [[ "${DB_LOCATION}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided database location '${DB_LOCATION}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${DB_NAME}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided database name '${DB_NAME}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${DB_USERNAME}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided database user name '${DB_USERNAME}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${LOG_LEVEL}" =~ ^[0-9]+$ ]]; then
        echo >&2 "Error: Provided tine log level '${LOG_LEVEL}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${ADMIN_NAME}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided admin user name '${ADMIN_NAME}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${SETUP_NAME}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided setup user name '${SETUP_NAME}' contains invalid characters."
        exit 1
    fi
    if ! [[ "${SERVER_NAME}" =~ ^[0-9a-zA-Z.]+$ ]]; then
        echo >&2 "Error: Provided server name '${SERVER_NAME}' contains invalid characters."
        exit 1
    fi
    echo " * Checking validity of environment variables ... done"
}

function ensure_correct_ownership_of_tine20_log_and_lib_directory() {
    echo " * Setting correct ownership for /var/log/tine20/ and /var/lib/tine20/ ..."
    chown www-data:www-data     /var/log/tine20 \
 && chown www-data:www-data -R  /var/lib/tine20
    echo " * Setting correct ownership for /var/log/tine20/ and /var/lib/tine20/ ... done"
}

function ensure_correct_ownership_of_tine20_etc_directory() {
    echo " * Setting correct ownership for /etc/tine20/ ..."
    chown www-data:www-data -R  /etc/tine20
    echo " * Setting correct ownership for /etc/tine20/ ... done"
}

function ensure_correct_ownership_of_mysql_directory() {
    echo " * Setting correct ownership for /var/lib/mysql/ ..."
    chown mysql:mysql -R  /var/lib/mysql
    echo " * Setting correct ownership for /var/lib/mysql/ ... done"
}

function generate_timezone_information() {
    echo " * Generating timezone information ..."
    ln -fns "/usr/share/zoneinfo/${TIMEZONE}" "/etc/localtime"
    echo "${TIMEZONE}" >                      "/etc/timezone"
    echo " * Generating timezone information ... done"
}

function is_directory_empty() {
    local VAR_PATH_TO_DIRECTORY=${1}

    if [ ! -d ${VAR_PATH_TO_DIRECTORY} ] || [ -z "$( ls -A ${VAR_PATH_TO_DIRECTORY} )" ];
    then
        echo "true"
    else
        echo "false"
    fi
}

function import_tine20_configuration_directory_if_necessary() {
    echo " * Importing tine20 configuration directory ..."

    local VAR_IS_EMPTY=$( is_directory_empty /etc/tine20 )

    if [ "${VAR_IS_EMPTY}" = "true" ];
    then
        cp -pr /import/etc/tine20/. /etc/tine20
        echo " * Importing tine20 configuration directory ... done"
    else
        echo " * Importing tine20 configuration directory ... skipped"
    fi
}

function generate_tine20_php_configuration_file() {
    echo " * Generating tine20 php configuration file ..."
    mkdir -p "/usr/share/tine20"
    sed -e "s/\${TINE20_DB_USERNAME}/${DB_USERNAME}/g"       \
        -e "s/\${TINE20_DB_USERPASS}/${DB_PASSWORD}/"        \
        -e "s/\${TINE20_DB_LOCATION}/${DB_LOCATION}/"        \
        -e "s/\${TINE20_DB_NAME}/${DB_NAME}/"                \
        -e "s/\${TINE20_LOG_LEVEL}/${LOG_LEVEL}/"            \
        -e "s/\${TINE20_SETUP_USERNAME}/${SETUP_NAME}/"      \
        -e "s/\${TINE20_SETUP_USERPASS}/${SETUP_PASS}/"      \
        -e "s/\${SERVER_SCHEME}/${SERVER_SCHEME}/"                  \
        -e "s/\${SERVER_NAME}/${SERVER_NAME}/"                      \
        "/templates/config.inc.php.dist"                                \
        > "/etc/tine20/config.inc.php"
    echo " * Generating tine20 php configuration file ... done"
}

function generate_tine20_apache_configuration_file() {
    echo " * Generating tine20 apache configuration file ..."
    sed -e "s/\${SERVER_NAME}/${SERVER_NAME}/g" \
        "/templates/apache.conf"                    \
        > "/etc/tine20/apache.conf"
    echo " * Generating tine20 apache configuration file ... done"
}

function import_pre_configured_database_configuration_if_database_directory_is_empty() {
    local VAR_IS_DATABASE_DIRECTORY_EMPTY=${1}

    if [ "${VAR_IS_DATABASE_DIRECTORY_EMPTY}" = "true" ];
    then
        echo " * Importing pre-configured mysql database configuration ..."
        cp -pr "/import/var/lib/mysql/." "/var/lib/mysql/"
        echo " * Importing pre-configured mysql database configuration ... done"
    fi
}

function create_tine20_database_if_database_directory_is_empty() {
    local VAR_IS_DATABASE_DIRECTORY_EMPTY=${1}

    if [ "${VAR_IS_DATABASE_DIRECTORY_EMPTY}" = "true" ];
    then
        echo " * Creating tine20 database '${DB_NAME}' ..."
        service mysql restart                                                                                                                                                      \
        && mysql --execute="CREATE DATABASE ${DB_NAME} DEFAULT CHARACTER SET 'UTF8';"                                                                                   \
        && mysql --execute="GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USERNAME}'@'${DB_LOCATION}' IDENTIFIED BY '${DB_PASSWORD}';"
        echo " * Creating tine20 database '${DB_NAME}' ... done"
    fi
}

function install_tine20_applications() {
    echo " * Installing tine20 applications ..."
    sudo -u www-data php "/usr/share/tine20/setup.php"   \
            --config=/etc/tine20/config.inc.php          \
            --install                                    \
            -- adminLoginName="${ADMIN_NAME}" \
               adminPassword="${ADMIN_PASS}"  \
               acceptedTermsVersion=100
    echo " * Installing tine20 applications ... done"
}

function enable_tine20_apache_configuration() {
    echo " * Enable tine20 apache configuration ..."
    ln --symbolic --force                      \
       /etc/tine20/apache.conf                 \
       /etc/apache2/conf-available/tine20.conf \
 && ln --symbolic --force                      \
       /etc/apache2/conf-available/tine20.conf \
       /etc/apache2/conf-enabled/tine20.conf
    echo " * Enable tine20 apache configuration ... done"
}

function map_tine20_php_configuration_file_to_web_root_directory() {
    echo " * Link tine20 php configuration to web root directory ..."
    if [ -f "/etc/tine20/config.inc.php" ];
    then
        ln --symbolic --force               \
           /etc/tine20/config.inc.php       \
           /usr/share/tine20/config.inc.php
        echo " * Link tine20 php configuration to web root directory ... done"
    else
        echo " * Link tine20 php configuration to web root directory ... skipped"
    fi
}

function configure_apache2_server_name() {
    echo " * Configuring apache2 server name ..."
    echo "ServerName ${SERVER_NAME}" \
      >> "/etc/apache2/apache2.conf"
    echo " * Configuring apache2 server name ... done"
}

echo "Preparing tine20 environment ..."

check_system_environment
check_system_environment_validity

ensure_correct_ownership_of_tine20_log_and_lib_directory
generate_timezone_information

echo "Preparing tine20 environment ... done"

CONST_MARKER_FOR_SUCCESSFUL_SETUP="/var/lib/tine20/setup/.setup-was-successful"

if [ ! -f "${CONST_MARKER_FOR_SUCCESSFUL_SETUP}" ];
then
    echo "Performing tine20 setup ..."

    VAR_IS_DATABASE_DIRECTORY_EMPTY="$( is_directory_empty /var/lib/mysql )"

    generate_timezone_information
    import_tine20_configuration_directory_if_necessary
    generate_tine20_php_configuration_file
    generate_tine20_apache_configuration_file
    import_pre_configured_database_configuration_if_database_directory_is_empty ${VAR_IS_DATABASE_DIRECTORY_EMPTY}
    create_tine20_database_if_database_directory_is_empty                       ${VAR_IS_DATABASE_DIRECTORY_EMPTY}
    install_tine20_applications

    echo "${TINE20_VERSION}" > "${CONST_MARKER_FOR_SUCCESSFUL_SETUP}"
    echo "Performing tine20 setup ... done"
fi

echo "Starting tine20 ..."

ensure_correct_ownership_of_tine20_etc_directory
ensure_correct_ownership_of_mysql_directory
keep_timezone_information_up_to_date
map_tine20_php_configuration_file_to_web_root_directory
enable_tine20_apache_configuration
configure_apache2_server_name

service mysql   restart
service apache2 restart

if [ -f "${CONST_MARKER_FOR_SUCCESSFUL_SETUP}" ];
then
    echo "Performing tine20 upgrade ..."
    if [ "${TINE20_VERSION}" = "$( cat ${CONST_MARKER_FOR_SUCCESSFUL_SETUP} )" ];
    then
        echo "Performing tine20 upgrade ... skipped"
    else
        php setup.php --update
        service mysql   restart
        service apache2 restart
        echo "${TINE20_VERSION}" > "${CONST_MARKER_FOR_SUCCESSFUL_SETUP}"
        echo "Performing tine20 upgrade ... done"
    fi
fi

sleep infinity & \
VAR_SLEEP=${!}

echo "Starting tine20 ... done"

trap 'echo "Stopping tine20 ...";      \
      kill -TERM ${VAR_SLEEP};         \
      service apache2 stop;            \
      service mysql   stop;            \
      echo "Stopping tine20 ... done"; \
      exit 0'                          \
    SIGTERM

wait ${VAR_SLEEP}
