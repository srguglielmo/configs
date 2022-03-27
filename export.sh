#!/usr/bin/sh
#
# Sync the config files from this git repo to the system (i.e. an export).
#

set -o errexit -o nounset
export PATH=/usr/bin:/bin

# Ensure find is in the PATH.
if ! command -v find 1>/dev/null; then
	printf 'ERROR: Missing find in PATH.\n'
	exit 1
fi

# Ensure rsync is in the PATH.
if ! command -v rsync 1>/dev/null; then
	printf 'ERROR: Missing rsync in PATH.\n'
	exit 1
fi

# Ensure sed is in the PATH.
if ! command -v sed 1>/dev/null; then
	printf 'ERROR: Missing sed in PATH.\n'
	exit 1
fi

# Require one argument.
if [ $# -ne 1 ]; then
	printf 'ERROR: Missing argument.\n'
	printf 'Usage: %s USER\n\n' "$0"
	printf 'USER: The username on the local machine to sync with.\n'
	printf 'E.g. `%s foobar` will rsync /home/foobar/.\n' "$0"
	exit 1
fi

IMPORT_DIR="./files/"
EXPORT_DIR="/home/$1/"
printf 'IMPORTING FROM: %s\n' "$IMPORT_DIR"
printf 'EXPORTING TO: %s\n' "$EXPORT_DIR"

# Validate local paths.
if [ ! -d "$EXPORT_DIR" ]; then
	printf 'ERROR: Directory "%s" does not exist.\n' "$EXPORT_DIR"
	exit 1
fi
if [ ! -r "$EXPORT_DIR" ]; then
	printf 'ERROR: Directory "%s" is not readable.\n' "$EXPORT_DIR"
	exit 1
fi
if [ ! -w "$EXPORT_DIR" ]; then
	printf 'ERROR: Directory "%s" is not writable.\n' "$EXPORT_DIR"
	exit 1
fi
if [ ! -x "$EXPORT_DIR" ]; then
	printf 'ERROR: Directory "%s" is not searchable.\n' "$EXPORT_DIR"
	exit 1
fi

rsync -vvrhhlcs --info=NAME1 --files-from=rsync_list.txt --ignore-missing-args --dry-run "$IMPORT_DIR" $EXPORT_DIR

printf "Done!\n"
exit 0


