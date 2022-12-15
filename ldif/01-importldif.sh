#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/../.env"

echo "[TEST] Generating test LDIF data" 2>&1

"$WRENDS_HOME/bin/makeldif" \
        -o $WRENDS_TEST/ldif/data/generated.ldif \
        $WRENDS_TEST/ldif/config/MakeLDIF/example.template

echo "[TEST] Stopping the server and importing LDIF data" 2>&1

"$WRENDS_HOME/bin/stop-ds"
"$WRENDS_HOME/bin/import-ldif" \
        --offline \
        --includeBranch dc=example,dc=com \
        --backendID userRoot \
        --ldifFile $WRENDS_TEST/ldif/data/generated.ldif

echo "[TEST] Tests were all successful" 2>&1

