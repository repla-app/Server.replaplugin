#!/bin/sh

set -e

default_message="false"
while getopts ":r:m:u:edh" option; do
  case "$option" in
    r)
      SERVER_ROOT=$OPTARG
      ;;
    u)
      url=$OPTARG
      ;;
    m)
      message=$OPTARG
      ;;
    e)
      echo_redir=">&2"
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
  # The output specifies a port which will automatically load a URL so strip
  # those lines so that with default output there is no URL to automatically
  # load.
  echo "$x" $echo_redir | grep -v port
  if [[ $x == *"WEBrick"* ]]; then
    if [[ -n "$url" ]]; then
      if [[ -n "$message" ]]; then
        echo "$message $url" $echo_redir
      else
        echo "Server started at $url" $echo_redir
      fi
    fi
    if [[ "$default_message" == "true" ]]; then
      echo "Server started at http://127.0.0.1:5000" $echo_redir
    fi
  fi
done
