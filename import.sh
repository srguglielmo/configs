#!/usr/bin/sh
#
# Sync the config files from the system to this git repo (i.e. an import).
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

IMPORT_DIR="/home/$1/"
EXPORT_DIR="./files/"
printf 'IMPORTING FROM: %s\n' "$IMPORT_DIR"
printf 'EXPORTING TO: %s\n' "$EXPORT_DIR"

# Validate local paths.
if [ ! -d "$IMPORT_DIR" ]; then
	printf 'ERROR: Directory "%s" does not exist.\n' "$IMPORT_DIR"
	exit 1
fi
if [ ! -r "$IMPORT_DIR" ]; then
	printf 'ERROR: Directory "%s" is not readable.\n' "$IMPORT_DIR"
	exit 1
fi
if [ ! -x "$IMPORT_DIR" ]; then
	printf 'ERROR: Directory "%s" is not searchable.\n' "$IMPORT_DIR"
	exit 1
fi

rsync -vvrhhlcs --info=NAME1 --files-from=rsync_list.txt --ignore-missing-args "$IMPORT_DIR" $EXPORT_DIR

# Post processing: Remove lines between '##STARTDELETE' and '##STOPDELETE'.
find $EXPORT_DIR -type f -print0 | xargs -0rt sed -i '/^##STARTDELETE/,/^##STOPDELETE/d'

printf "Done!\n"
exit 0
