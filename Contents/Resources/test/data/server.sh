#!/usr/bin/env bash

set -e

trap 'kill $(jobs -p)' EXIT

ruby -run -e httpd -- -p 5000 $SERVER_PATH 2>&1 | while read x; do echo $x; if [[ $x == *"WEBrick::HTTPServer#start"* ]]; then echo "Server started at http://127.0.0.1:5000"; fi done
