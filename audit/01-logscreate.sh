#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../.common.sh"

log_message "Creating csv file log"
exec_ds 1 dsconfig \
  --hostname localhost \
  --port 4444 \
  --trustAll \
  --bindDn "cn=Directory Manager" \
  --bindPassword password \
  --no-prompt \
  create-log-publisher \
  --publisher-name csv-file-access-log-publisher-test \
  --type csv-file-access \
  --set enabled:true

# TODO do a test search and check access log content

log_message "Tests were all successful"
