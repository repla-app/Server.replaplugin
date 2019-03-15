#!/usr/bin/env bash

set -e

env="$1"
command="$2"

process_env() {
  old_IFS=$IFS
  IFS=$'\n'
  for i in "$@"; do
    printf "%q " $i
  done
  IFS=${old_IFS}
}

env_arg=$(process_env "$env")
eval "env $env_arg $command"
