#! /usr/bin/env bash
# GENERATED FILE DO NOT EDIT
#
# Params:
# - RUNFILES_LOCAL_PATH: {{RUNFILES_LOCAL_PATH}}
# - BINARY_RELATIVE_PATH: {{BINARY_RELATIVE_PATH}}
set -e

command -v awk >/dev/null 2>&1 || ( echo "no awk" ; exit 1)
command -v tar >/dev/null 2>&1 || ( echo "no tar" ; exit 1)

DIR="$(mktemp -d -t shar.binary-XXXXXX)"

function cleanup() {
		rm -fr "${DIR}"
}
if [[ ${DEBUG} != "1" ]]; then
	trap cleanup EXIT
fi

readonly FILE_PATH="$0"
readonly ABSOLUTE_PATH=$(cd "$(dirname "$FILE_PATH")" && pwd -P)/"$(basename "$FILE_PATH")"

cd "${DIR}"
RUNFILES_DIR="$PWD/{{RUNFILES_LOCAL_PATH}}"
(
	readonly ARCHIVE=$(awk '/^__ARCHIVE_FOLLOWS__/ {print NR + 1; exit 0; }' "$ABSOLUTE_PATH")
	# Skip the stub and pipe the rest (the tarball) to tar
	tail -n +$ARCHIVE "$ABSOLUTE_PATH" | tar x
)

cd "${RUNFILES_DIR}/_main"
RUNFILES_DIR="${RUNFILES_DIR}" "{{BINARY_RELATIVE_PATH}}"
exit 0
__ARCHIVE_FOLLOWS__
