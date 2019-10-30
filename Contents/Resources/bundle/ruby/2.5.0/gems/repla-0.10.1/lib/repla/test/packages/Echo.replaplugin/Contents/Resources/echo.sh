#!/usr/bin/env bash

if [[ -n "$1" ]]; then
  echo "$@"
else
  echo "$ECHO_MESSAGE"
fi

