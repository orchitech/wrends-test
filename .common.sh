#!/bin/bash

set -eu -o pipefail

trap "log_error Test failure!" ERR

function log_message {
  echo -e "\033[0;33m[TEST] $*\033[0m" >&2
}

function log_error {
  echo -e "\033[0;31m[ERROR] $*\033[0m" >&2
}

function await_confirm {
  echo -n "$1 (y/n)? "
  read answer
  if [ "$answer" != "${answer#[Yy]}" ]; then
    echo
  else
    log_error
    exit 1
  fi
}

function check_network() {
  docker network inspect wrends > /dev/null && return 0
  log_message "Creating Docker network..."
  docker network create wrends
}

function start_ds() {
  check_network
  instance_id=${1:-1}
  log_message "Starting Wren:DS test instance $instance_id..."
  docker run \
      -d --rm --name "wrends-test"$instance_id --network wrends \
      -p $instance_id"389:1389" -p $instance_id"636:1636" \
      -e ADD_BASE_ENTRY="${ADDITIONAL_SETUP_ARGS:---addBaseEntry}" \
      ${WRENDS_IMAGE:-wrends}
  while true; do
    check_ds $instance_id && break
    log_message "Waiting for the container to startup..."
    sleep 1
  done
  log_message "Wren:DS instance $instance_id started."
}

function check_ds {
  instance_id=${1:-1}
  status=$(docker exec -it "wrends-test"$instance_id bin/status -ns || :)
  return $(echo $status | grep "Server Run Status: Started" > /dev/null)
}

function stop_ds {
  instance_id=${1:-1}
  log_message "Stopping Wren:DS test instance $instance_id..."
  docker exec -it "wrends-test"$instance_id ./bin/stop-ds || :
}

function exec_ds {
  instance_id=$1
  docker exec -it "wrends-test"$instance_id "${@:2}"
}

function cp_ds {
  docker cp "$1" "wrends-test$2"
}

function fail_test {
  log_error "$@"
  exit 1
}

function expect_result {
  grep 'dn: ' > /dev/null || fail_test "Expected result"
}

function expect_no_result {
  grep 'dn: ' > /dev/null && fail_test "Expected no result" || :
}

function test_exit_code() {
  EXITCODE=$?
  test $EXITCODE -eq 0 && echo "Testing was succesful" || echo "Testing failed";
  exit $EXITCODE
}
