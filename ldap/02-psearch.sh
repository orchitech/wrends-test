#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../.common.sh"

log_message "Starting persistent search job"

search_output_path=$(mktemp /tmp/wrends-test-psearch-XXXXX)
trap 'rm "$search_output_path"' EXIT

exec_ds 1 ldapsearch \
    --port 1389 --bindDN "cn=Directory Manager"  --bindPassword password \
    --baseDN dc=example,dc=com --persistentSearch ps:any:true:true "(objectClass=*)" > $search_output_path &
search_job_id=$!

log_message "Perform LDAP modification request"

exec_ds 1 ldapmodify \
    --port 1389 --bindDN "cn=Directory Manager"  --bindPassword password <<'END' || :
dn: dc=example,dc=com
changetype: modify
replace: description
description: bar
END

# Wait for output file to be populated
for _ in {1..5}; do
    [ -s "$search_output_path" ] && break
    sleep 1
done

diff --ignore-blank-lines "$search_output_path" - <<< "# Persistent search change type:  modify
dn: dc=example,dc=com
objectClass: top
objectClass: domain
dc: example
description: bar" || fail_test "Captured modification mismatch"

log_message "Stopping persistent search job"

kill -SIGINT $search_job_id

log_message "Tests were all successful"
