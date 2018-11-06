#!/usr/bin/env bash

. $(dirname "$0")/common.sh

set -e

check_for_depends

if (($# < 3)); then
    echo "Usage: $(basename $0) [version] [revision] [formula_files...]" >&2
    exit 1
fi

version=$1
rev=$2
formula_files=${@:3}
echo "version: $version, revision: $rev, formula_files: $formula_files"

# Update formulae with new version
sed -i.bk "s/:tag => \".*\",/:tag => \"$version\",/g" $formula_files
sed -i.bk "s/:revision => \".*\"/:revision => \"$rev\"/g" $formula_files
