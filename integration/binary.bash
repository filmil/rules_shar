#! /usr/bin/env bash

echo "hello world! from $PWD"
# All libraries used in this script are relative
# to ${RUNFILES_DIR}/_main
./lib/lib.sh
