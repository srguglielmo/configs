#!/usr/bin/env bash
#
# Arch system update.
#

set -o errexit -o nounset -o pipefail
export PATH=/usr/bin:~/go/bin

# Update the mirrorlist.
doas systemctl start reflector

# Refresh the files database.
doas pacman -Fy

# Sync the package database and update all packages.
doas pacman -Syu

# Cleanup the cache.
doas pacman -Sc --noconfirm

# Update all go packages.
gup update

# Update Composer packages.
( cd ~/Code/composer && composer update )

# Now check AUR packages.
while IFS= read -r -d $'\0' -u "$fd" AUR_PKG_FULL_PATH; do
	AUR_PKG=$(basename "$AUR_PKG_FULL_PATH")
	printf "Checking AUR package %s...\n" "$AUR_PKG"

	git -C "$AUR_PKG_FULL_PATH" checkout --quiet master
	git -C "$AUR_PKG_FULL_PATH" branch --quiet --set-upstream-to=aur/master
	git -C "$AUR_PKG_FULL_PATH" fetch --quiet aur

	if [[ "$(git -C "$AUR_PKG_FULL_PATH" rev-list --count HEAD...aur/HEAD)" != "0" ]]; then
		git -C "$AUR_PKG_FULL_PATH" log HEAD..aur/HEAD
		read -r -p "Upgrade AUR package? [Y/n] " REPLY
		case "$REPLY" in
			[Nn]*)
				printf "Skipping package %s...\n" "$AUR_PKG"
				;;
			*)
				printf "Upgrading package %s...\n" "$AUR_PKG"
				git -C "$AUR_PKG_FULL_PATH" merge --ff-only
				cd "$AUR_PKG_FULL_PATH"
				makepkg -cirs
				git clean -fd
		esac
	fi
done {fd}< <(find "${HOME}/Code/aur" -mindepth 1 -maxdepth 1 -type d -print0)

# Prompt for reboot
read -r -p 'System updated! Reboot? [Y/n] ' REPLY
case "$REPLY" in
	[Nn]*)
		exit 0
		;;
	*)
		printf "Rebooting...\n"
		systemctl reboot
esac

exit 0
