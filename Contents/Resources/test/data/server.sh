#!/bin/bash

set -e

default_message="false"
while getopts ":r:u:dh" option; do
  case "$option" in
    r)
      SERVER_ROOT=$OPTARG
      ;;
    u)
      url=$OPTARG
      ;;
    d)
      default_message="true"
      ;;
    h)
      echo "Usage: server.sh [-hd] [-u URL] [-r ROOT]"
      exit 0
      ;;
    :)
      echo "Option -$OPTARG requires an argument" >&2
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

trap 'kill $(jobs -p)' EXIT

if [[ -z "$SERVER_ROOT" ]]; then
  SERVER_ROOT="."
fi

ruby -run -e httpd -- -p 5000 "$SERVER_ROOT" 2>&1 | while read -r x; do
  echo "$x"
  if [[ $x == *"WEBrick::HTTPServer#start"* ]]; then
    echo "Server started at http://127.0.0.1:5000";
  fi
done
