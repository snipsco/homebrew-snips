#!/usr/bin/env bash

set -e

usage() {
    echo "Usage: $(basename $0) [version] [revision] [formula_files...]" >&2
}

check_for_depends() {
    local my_needed_commands="aws brew sed"

    local missing_counter=0
    for needed_command in $my_needed_commands; do
      if ! hash "$needed_command" >/dev/null 2>&1; then
        printf "Command not found in PATH: %s\n" "$needed_command" >&2
        ((missing_counter++))
      fi
    done

    if ((missing_counter > 0)); then
      printf "%d commands are missing in PATH, aborting\n" "$missing_counter" >&2
      exit 1
    fi
}

main() {
    local version=$1
    local rev=$2
    local formula_files=${@:3}

    echo "version: $version, revision: $rev, formula_files: $formula_files"

    # Update formulae with new version
    sed -i.bk "s/:tag => \".*\"/:tag => \"$version\"/g" $formula_files
    sed -i.bk "s/:revision => \".*\"/:revision => \"$rev\"/g" $formula_files

    # Just audit code style formulae. This could avoid obvious issues
    brew audit --strict --online $formula_files

    # Uninstall formulae because if they already exist, the install will fail
    brew uninstall $formula_files --force --ignore-dependencies

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
        --or-later \
        --json

    # Update formulae with new hashes
    brew bottle \
        --merge \
        --write \
        --no-commit \
        $(find . -name "*.bottle.json")

    # Upload bottle on s3
    aws s3 cp . "s3://homebrew.snips.ai/bottles" \
        --acl public-read \
        --recursive \
        --exclude "*" \
        --include "*.bottle.tar.gz"
}

# Exec

check_for_depends

if (($# < 3)); then
    usage
    exit 1
fi

main $1 $2 ${@:3}

