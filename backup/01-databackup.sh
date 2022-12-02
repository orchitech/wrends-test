#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/../.env"

echo "[TEST] Stopping server and starting backup operation" 2>&1

"$WRENDS_HOME/bin/stop-ds"
"$WRENDS_HOME/bin/backup" \
        --offline \
        --backupDirectory "$WRENDS_HOME/bak" \
        --bindDn "cn=Directory Manager" \
        --bindPassword password \
        --backupAll

echo "[TEST] All tests were successful" 2>&1