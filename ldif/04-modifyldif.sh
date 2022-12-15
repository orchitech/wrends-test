#!/bin/bash

set -e

. "$(dirname "${BASH_SOURCE[0]}")/../.env"

echo "[TEST] Show changes to the user" 2>&1

cat "$WRENDS_TEST/ldif/data/changes.ldif"

echo "[TEST] Modify the user" 2>&1

"$WRENDS_HOME/bin/ldifmodify" \
        --outputLdif "$WRENDS_TEST/ldif/data/new.ldif" \
        "$WRENDS_TEST/ldif/data/generated.ldif" \
        "$WRENDS_TEST/ldif/data/changes.ldif"

echo "[TEST] Search for modified user" 2>&1

"$WRENDS_HOME/bin/ldifsearch" \
        --baseDN dc=example,dc=com \
        $WRENDS_TEST/ldif/data/new.ldif \
        "(uid=user.0)"

echo "[TEST] Tests were all successful" 2>&1