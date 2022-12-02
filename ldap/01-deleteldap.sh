#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/../.env"

echo "[TEST] Starting the server deleting data and stopping server." 2>&1

"$WRENDS_HOME/bin/start-ds"
"$WRENDS_HOME/bin/ldapdelete" \
        --port 1389 \
        --bindDn "cn=Directory Manager" \
        --bindPassword password \
        uid=user.0,ou=Org-0,ou=People,dc=example,dc=com
"$WRENDS_HOME/bin/stop-ds"

echo "[TEST] Tests were all successful" 2>&1
