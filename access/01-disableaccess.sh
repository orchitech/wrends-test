#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../.common.sh"

log_message "Using anonymous search for (uid=user.1)"
exec_ds 1 ./bin/ldapsearch --port 1389 \
  --baseDN dc=example,dc=com "(uid=user.1)" sn | expect_result

log_message "Removing anonymous search"
exec_ds 1 ./bin/dsconfig \
  --hostname localhost --port 4444 --trustAll --bindDN "cn=Directory Manager" --bindPassword password --no-prompt \
  set-access-control-handler-prop \
  --remove 'global-aci:(targetattr!="userPassword||authPassword||debugsearchindex||changes||changeNumber||changeType||changeTime||targetDN||newRDN||newSuperior||deleteOldRDN")(version 3.0; acl "Anonymous read access"; allow (read,search,compare) userdn="ldap:///anyone";)'

log_message "Using anonymous search again for (uid=user.1)"
exec_ds 1 ./bin/ldapsearch --port 1389 \
  --baseDN dc=example,dc=com "(uid=user.1)" sn | expect_no_result

log_message "Using non-anonymous search for (uid=user.1)"
exec_ds 1 ./bin/ldapsearch --port 1389 --hostname localhost --bindDN "cn=Directory Manager" --bindPassword password \
  --baseDN dc=example,dc=com "(uid=user.1)" sn | expect_result

log_message "All tests were successful"
