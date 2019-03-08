#!/usr/bin/env bash

set -e

ruby -run -e httpd -- -p 5000 $SERVER_PATH
