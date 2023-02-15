#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../.common.sh"

log_message "Copying ldif files into Docker image"
cp_ds ./schema/data/blogUrlAt.ldif 1:/tmp
cp_ds ./schema/data/blogUrlOc.ldif 1:/tmp
cp_ds ./schema/data/blogger.ldif 1:/tmp

log_message "Creating new attribute type and object class"
exec_ds 1 ldapmodify --hostname localhost --port 4444 --trustAll --bindDN "cn=Directory Manager"  --bindPassword password  --useSSL \
  --filename /tmp/blogUrlAt.ldif
exec_ds 1 ldapmodify --hostname localhost --port 4444 --trustAll --bindDN "cn=Directory Manager"  --bindPassword password  --useSSL \
  --filename /tmp/blogUrlOc.ldif

log_message "Creating new record with created object class"
exec_ds 1 ldapmodify --hostname localhost --port 4444 --trustAll --bindDN "cn=Directory Manager"  --bindPassword password  --useSSL \
  --filename /tmp/blogger.ldif

log_message "Searching for the addition"
exec_ds 1 ldapsearch --hostname localhost --port 4444 --trustAll --bindDN "cn=Directory Manager"  --bindPassword password  --useSSL \
  --baseDN cn=schema --searchScope base "(objectclass=*)" objectClasses | grep 'blogger'

log_message "Searching for the newly created record"
exec_ds 1 ldapsearch --hostname localhost --port 4444 --trustAll --bindDN "cn=Directory Manager"  --bindPassword password --useSSL \
  --baseDN dc=example,dc=com "(blog=Test)" "blog" | expect_result

log_message "Tests were all successful"