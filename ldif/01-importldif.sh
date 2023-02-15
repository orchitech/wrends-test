#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../.common.sh"

log_message "Copy template into Docker image"
cp_ds ./ldif/template/example.template 1:/tmp

log_message "Generating ldif file based on copied template file."
exec_ds 1 makeldif --outputLdif /tmp/generated.ldif /tmp/example.template

log_message "Importing generated ldif file."
exec_ds 1 import-ldif \
  --hostname localhost --port 4444 --trustAll --bindDN "cn=Directory Manager" --bindPassword password \
  --includeBranch dc=example,dc=com --ldifFile /tmp/generated.ldif

log_message "Tests were all successful"