#!/usr/bin/env bash

. $(dirname "$0")/common.sh

set -e

check_for_depends

if (($# < 1)); then
    echo "Usage: $(basename $0) [formula_files...]" >&2
    exit 1
fi

formula_files=${@:1}


# Uninstall formulae because if they already exist, the install will fail
for i in `brew list | grep snips` ; do brew uninstall $i  --force --ignore-dependencies ; done

# Build bottle formulae 
brew install $formula_files \
    --build-bottle \
    --display-times \
    --verbose \
    --keep-tmp \
    --include-test

# Generate bottle(s) and merge json file(s)
brew bottle $formula_files \
    --root-url="https://homebrew.snips.ai/bottles" \
    --force-core-tap \
    --json
