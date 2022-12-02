#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/../.env"

echo "[TEST] Starting the server and starting config" 2>&1

"$WRENDS_HOME/bin/start-ds"
"$WRENDS_HOME/bin/dsconfig" --hostname localhost --port 4444 --bindDn "cn=Directory Manager" --bindPassword password
"$WRENDS_HOME/bin/stop-ds"

echo "[TEST] Tests were all successful" 2>&1