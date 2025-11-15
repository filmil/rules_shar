#! /usr/bin/env bash
set -e
readonly SHAR="${1}"
unset RUNFILES_DIR
echo FOO
"${SHAR}"
echo BAR
