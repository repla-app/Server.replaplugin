#!/usr/bin/env bash

set -e

echo "$TEST_VARIABLE"
echo "$TEST_VARIABLE_TWO" >&2
# The new lines help flush the `STDOUT` and `STDERR` caches
echo
echo >&2
