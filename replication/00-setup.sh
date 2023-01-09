#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../.common.sh"

ADDITIONAL_SETUP_ARGS="--sampleData 10" start_ds 1
start_ds 2
