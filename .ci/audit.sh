#!/usr/bin/env bash

. $(dirname "$0")/common.sh

set -e

check_for_depends

if (($# < 1)); then
    echo "Usage: $(basename $0) [formula_files...]" >&2
    exit 1
fi

formula_files=${@:1}
echo "formula_files: $formula_files"

# Just audit formulae code style just to avoid obvious issues
brew audit --strict --online $formula_files
