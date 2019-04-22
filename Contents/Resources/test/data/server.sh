#!/bin/bash

set -e

trap 'kill $(jobs -p)' EXIT

if [[ -n "$1" ]]; then
  SERVER_ROOT="$1"
fi

if [[ -z "$SERVER_ROOT" ]]; then
  SERVER_ROOT="."
fi

ruby -run -e httpd -- -p 5000 "$SERVER_ROOT" 2>&1 | while read x; do echo $x; if [[ $x == *"WEBrick::HTTPServer#start"* ]]; then echo "Server started at http://127.0.0.1:5000"; fi done
