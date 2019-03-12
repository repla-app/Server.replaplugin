#!/usr/bin/env bash

set -e

trap 'kill $(jobs -p)' EXIT

if [[ -n "$1" ]]; then
  SERVER_PATH="$1"
fi

if [[ -z "$SERVER_PATH" ]]; then
  SERVER_PATH="."
fi
ruby -run -e httpd -- -p 5000 $SERVER_ROOT 2>&1 | while read x; do echo $x; if [[ $x == *"WEBrick::HTTPServer#start"* ]]; then echo "Server started at http://127.0.0.1:5000"; fi done
