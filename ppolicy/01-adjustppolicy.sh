#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../.common.sh"

# TODO check that password policy is not enforced

log_message "Searching for custom password policy (Test Password Policy)"
exec_ds 1 dsconfig \
  --hostname localhost --port 4444 --bindDN "cn=Directory Manager"  --bindPassword password --trustAll --no-prompt \
  get-password-policy-prop \
  --policy-name "Test Password Policy" && :

log_message "Creating new password policy (Test Password Policy)"
exec_ds 1 dsconfig --hostname localhost --port 4444 --bindDN "cn=Directory Manager"  --bindPassword password --trustAll --no-prompt \
  create-password-policy \
  --type password-policy \
  --policy-name "Test Password Policy" --set password-attribute:userPassword \
  --set default-password-storage-scheme:"Salted SHA-1" \
  --set lockout-duration:300s --set lockout-failure-count:3 \
  --set password-change-requires-current-password:true

log_message "Searching again for custom password policy (Test Password Policy)"
exec_ds 1 dsconfig --hostname localhost --port 4444 --bindDN "cn=Directory Manager"  --bindPassword password --trustAll --no-prompt \
  get-password-policy-prop \
  --policy-name "Test Password Policy" && : || fail_test "Expected result"

# TODO check that the password policy is enforeced

log_message "Tests were all successful"