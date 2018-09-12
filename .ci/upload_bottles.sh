#!/usr/bin/env bash

. $(dirname "$0")/common.sh

set -e

check_for_depends

# Upload bottle on s3
aws s3 cp . "s3://homebrew.snips.ai/bottles" \
    --acl public-read \
    --recursive \
    --exclude "*" \
    --include "*.bottle.tar.gz"
