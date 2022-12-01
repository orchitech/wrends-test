#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/../.env"

echo "[TEST] Setting up server with sample data" 2>&1

"$WRENDS_HOME/setup" \
        --cli \
        --backendType je \
        --baseDN dc=example,dc=com \
        --sampleData 200 \
        --ldapPort 1389 \
        --adminConnectorPort 4444 \
        --rootUserDN "cn=Directory Manager" \
        --rootUserPassword password \
        --no-prompt \
        --noPropertiesFile

echo "[TEST] Checking server status" 2>&1

"$WRENDS_HOME/bin/status" \
        --bindDN "cn=Directory Manager" \
        --bindPassword password

echo "[TEST] Stopping server instance" 2>&1

"$WRENDS_HOME/bin/stop-ds"

echo "[TEST] Tests were all successful" 2>&1
