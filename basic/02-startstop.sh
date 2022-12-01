#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/../.env"

echo "[TEST] Starting up server instance" 2>&1

"$WRENDS_HOME/bin/start-ds"

echo "[TEST] Checking server status" 2>&1

"$WRENDS_HOME/bin/status" \
        --bindDN "cn=Directory Manager" \
        --bindPassword password

echo "[TEST] Stopping server instance" 2>&1

"$WRENDS_HOME/bin/stop-ds"

echo "[TEST] Tests were all successful" 2>&1
