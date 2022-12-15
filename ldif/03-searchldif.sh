#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/../.env"

echo "[TEST] Beginning to search for user with attribute: sn=Amlani" 2>&1

"$WRENDS_HOME/bin/ldifsearch" \
        --baseDN dc=example,dc=com \
        $WRENDS_TEST/ldif/data/generated.ldif \
        "(sn=Amlani)" 

echo "[TEST] Tests were all successful" 2>&1