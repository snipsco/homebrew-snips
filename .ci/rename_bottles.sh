#!/usr/bin/env bash

# workaround due to `--` instead of `-` in output bottle filename
# see https://github.com/Homebrew/brew/issues/4740

. $(dirname "$0")/common.sh

set -e

check_for_depends

if (($# < 2)); then
    echo "Usage: $(basename $0) [bottle_json_files...]" >&2
    exit 1
fi

bottle_json_files=${@:1}

for json_file in "${bottle_json_files[@]}"
    local local_filename=$(jq '.[].bottle.tags[].local_filename' $json_file | head -n1)
    local filename=$(jq '.[].bottle.tags[].filename' $json_file | head -n1)

    echo "renaming $local_filename to $filename" 
    mv $local_filename $filename
do
