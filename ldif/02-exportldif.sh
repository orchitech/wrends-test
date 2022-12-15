#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/../.env"

echo "[TEST] Stopping the server and exporting LDIF data" 2>&1

"$WRENDS_HOME/bin/stop-ds"
"$WRENDS_HOME/bin/export-ldif" \
        --offline \
        --includeBranch dc=example,dc=com \
        --backendID userRoot \
        --ldifFile $WRENDS_TEST/ldif/data/exported.ldif

echo "[TEST] Tests were all successful" 2>&1