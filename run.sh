#!/bin/bash
#
# Simple script for running full test suite.
#

set -eu -o pipefail

# Hardcoded list of test categories
TEST_CATEGORIES=(
  "access"
  "audit"
  "authentication"
  "backup"
  "basic"
  "cli"
  "documentation"
  "ldap"
  "ldif"
  "limits"
  "monitoring"
  "package"
  "plugin"
  "ppolicy"
  "replication"
  "rest"
  "schema"
)

log_suite() {
  echo -e "\033[1;36m[SUITE] $1\033[0m" >&2
}

run_tests() {
  local category="$1"
  log_suite "Running '$category' tests"
  run-parts --regex '^[^\.].*.sh$' --exit-on-error "$category" -v
}

run_suite() {
  local skip=${RESUME_FROM:-}
  for category in ${TEST_CATEGORIES[@]}; do
    if [ "$category" == "$skip" ]; then
      skip=
    fi
    if [ ! -z "$skip" ]; then
      continue
    fi
    if ! run_tests "$category"; then
      return 1
    fi
  done
  log_suite "Finished running tests"
}

run_suite
