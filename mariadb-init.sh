#!/bin/bash
set -e

IFS=',' read -ra DATABASES <<<"$MARIADB_DATABASES"
IFS=',' read -ra USERS <<<"$MARIADB_USERS"
IFS=',' read -ra PASSWORDS <<<"$MARIADB_PASSWORDS"

for i in "${!DATABASES[@]}"; do
    echo CREATING DATABASE ${DATABASES[i]} with USER ${USERS[i]} / PASSWORD ${PASSWORDS[i]}!
    mariadb -u root -p"$MARIADB_ROOT_PASSWORD" <<-EOSQL
        CREATE DATABASE IF NOT EXISTS ${DATABASES[i]};
        CREATE USER IF NOT EXISTS '${USERS[i]}'@'%' IDENTIFIED BY '${PASSWORDS[i]}';
        GRANT ALL PRIVILEGES ON ${DATABASES[i]}.* TO '${USERS[i]}'@'%';
        FLUSH PRIVILEGES;
EOSQL
done
