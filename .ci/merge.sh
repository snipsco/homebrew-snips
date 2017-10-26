#!/usr/bin/env bash

. $(dirname "$0")/common.sh

set -e

check_for_depends

if (($# < 2)); then
    echo "Usage: $(basename $0) [bottle_json_files...]" >&2
    exit 1
fi

bottle_json_files=${@:1}

# Update formulae with new hashes
brew bottle \
    --merge \
    --write \
    --no-commit \
    $bottle_json_files
