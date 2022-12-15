#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/../.env"

echo "[TEST] Starting server instance, creating log"

"$WRENDS_HOME/bin/start-ds"
"$WRENDS_HOME/bin/dsconfig" \
        create-log-publisher \
        --publisher-name csv-file-access-log-publisher-test \
        --type csv-file-access \
        --set enabled:true \
        --hostname localhost \
        --port 4444 \
        --bindDn "cn=Directory Manager" \
        --bindPassword password \
        --trustAll \
        --no-prompt
"$WRENDS_HOME/bin/stop-ds"

echo "[TEST] Tests were all successful"