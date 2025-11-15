#! /usr/bin/env bash

echo "hello world! from $PWD"
# All libraries used in this script are relative
# to ${RUNFILES_DIR}
${RUNFILES_DIR}/example/lib/lib.sh
