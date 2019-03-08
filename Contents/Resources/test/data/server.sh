#!/usr/bin/env bash

set -e

trap 'kill $(jobs -p)' EXIT
ruby -run -e httpd -- -p 5000 $SERVER_PATH
