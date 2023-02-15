#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../.common.sh"

log_message "Starting backup operation"
exec_ds 1 bin/backup --port 4444 --bindDN "cn=Directory Manager"  --bindPassword password \
 --backUpAll --backupDirectory /opt/wrends/bak --start 0

log_message "Delete data point (uid=user.0,ou=People,dc=example,dc=com)"
exec_ds 1 ldapdelete \
    --port 1389 --bindDN "cn=Directory Manager"  --bindPassword password \
    uid=user.0,ou=People,dc=example,dc=com || fail_test "Unable to delete LDAP entry"

log_message "Search for data point (uid=user.0,ou=People,dc=example,dc=com)"
exec_ds 1 ldapsearch \
    --port 1389 --bindDN "cn=Directory Manager"  --bindPassword password \
    --baseDN dc=example,dc=com "(uid=user.0)" "uid" | expect_no_result

log_message "Restoring backup"
exec_ds 1 bin/restore --port 4444 --bindDN "cn=Directory Manager"  --bindPassword password \
 --backupDirectory /opt/wrends/bak/userRoot --start 0

log_message "Search for data point (uid=user.0,ou=People,dc=example,dc=com)"
exec_ds 1 ldapsearch \
    --port 1389 --bindDN "cn=Directory Manager"  --bindPassword password \
    --baseDN dc=example,dc=com  "(uid=user.0)" "uid" | expect_result

log_message "All tests were successful"
