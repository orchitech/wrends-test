#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../.common.sh"

log_message "Searching for non-existent entry on replica"
exec_ds 2 ldapsearch --port 1389 --hostname localhost --bindDN "cn=Directory Manager"  --bindPassword password \
  --baseDN dc=example,dc=com "(uid=user.0)" uid | expect_no_result

log_message "Setting up replication"
exec_ds 1 dsreplication enable --adminUID admin --adminPassword password --trustAll --no-prompt --baseDN dc=example,dc=com \
        --host1 wrends-test1 --port1 4444 --bindDN1 "cn=Directory Manager" \
        --bindPassword1 password --replicationPort1 8989 \
        --host2 wrends-test2 --port2 4444 --bindDN2 "cn=Directory Manager" \
        --bindPassword2 password --replicationPort2 8989
exec_ds 1 dsreplication initialize-all --adminUID admin --adminPassword password --trustAll --no-prompt \
        --baseDN dc=example,dc=com --hostname wrends-test1 --port 4444

log_message "Searching for imported data on replica"
exec_ds 2 ldapsearch --port 1389 --hostname localhost --bindDN "cn=Directory Manager"  --bindPassword password \
  --baseDN dc=example,dc=com "(uid=user.0)" sn | expect_result

log_message "Deleting one entry from replica"
exec_ds 2 ldapdelete --port 1389 --hostname localhost --bindDN "cn=Directory Manager"  --bindPassword password \
  uid=user.0,ou=People,dc=example,dc=com

# TODO wait for replication?
sleep 1

log_message "Searching for deleted entry on master server"
exec_ds 1 ldapsearch --port 1389 --hostname localhost --bindDN "cn=Directory Manager"  --bindPassword password \
  --baseDN dc=example,dc=com "(uid=user.0)" uid | expect_no_result

log_message "Testing successfuly completed!"
