#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../.common.sh"

log_message "Copy ldif template into docker image"
cp_ds ./data/ps.ldif 1:/tmp
log_message "Setup persistent search for all changes and modify data based on previously imported ldif file"
exec_ds 1 bash -c './bin/ldapsearch \
    --hostname localhost --port 1389  --bindDN "cn=Directory Manager" --bindPassword password \
    --baseDN dc=example,dc=com --verbose --persistentSearch ps:any:true:true "(objectclass=*)" | grep "#" &
    ./bin/ldapmodify \
    --hostname localhost --port 4444 --trustAll --bindDN "cn=Directory Manager"  --bindPassword password --useSSL \
    --filename /tmp/ps.ldif;'
test_exit_code
log_message "Succesful testing."

