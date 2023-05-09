#!/bin/bash

set -eu -o pipefail

trap "log_error Test failure!" ERR

log_message() {
  echo -e "\033[0;33m[TEST] $*\033[0m" >&2
}

log_error() {
  echo -e "\033[0;31m[ERROR] $*\033[0m" >&2
}

await_confirm() {
  echo -n "$1 (y/n)? "
  local answer
  read answer
  if [ "$answer" != "${answer#[Yy]}" ]; then
    echo
  else
    log_error
    exit 1
  fi
}

check_network() {
  docker network inspect wrends > /dev/null && return 0
  log_message "Creating Docker network..."
  docker network create wrends
}

start_ds() {
  check_network
  local instance_id=${1:-1}
  log_message "Starting Wren:DS test instance $instance_id..."
  docker run \
      -d --rm --name "wrends-test"$instance_id --network wrends \
      -p $instance_id"389:1389" -p $instance_id"636:1636" \
      -e ADDITIONAL_SETUP_ARGS="${ADDITIONAL_SETUP_ARGS:---addBaseEntry}" \
      ${WRENDS_IMAGE:-wrends}
  while true; do
    check_ds $instance_id && break
    log_message "Waiting for the container to startup..."
    sleep 1
  done
  log_message "Wren:DS instance $instance_id started."
}

check_ds() {
  local instance_id=${1:-1}
  # Call standard status command
  local status=$(exec_ds $instance_id status -ns || :)
  $(echo $status | grep "Server Run Status: Started" > /dev/null) || return 1
  # Perform user backend search (it starts a bit later than the container)
  exec_ds $instance_id ldapsearch --port 1389 \
      --bindDN "cn=Directory Manager" --bindPassword password \
      --baseDN "dc=example,dc=com" --searchScope one "(objectclass=*)" "dn" > /dev/null 2>&1
}

stop_ds() {
  local instance_id=${1:-1}
  log_message "Stopping Wren:DS test instance $instance_id..."
  docker stop "wrends-test"$instance_id
}

exec_ds() {
  local instance_id=$1
  docker exec -i "wrends-test"$instance_id "${@:2}"
}

cp_ds() {
  docker cp "$1" "wrends-test$2"
}

fail_test() {
  log_error "$@"
  exit 1
}

expect_result() {
  grep 'dn: ' > /dev/null || fail_test "Expected result"
}

expect_no_result() {
  grep 'dn: ' > /dev/null && fail_test "Expected no result" || :
}
