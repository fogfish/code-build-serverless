#!/bin/bash
set -eu

. /usr/local/bin/config-docker.sh

[[ $1 ]] && exec "$@"
