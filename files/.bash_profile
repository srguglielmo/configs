# (Shebang intentionally omitted)
# shellcheck shell=bash
#
# srg's ~/.bash_profile.
# Login shells (both interactive and not).
#

# If interactive, include .bashrc.
if [[ $- == *i* ]] && [ -f "${HOME}/.bashrc" ]; then
	source "$HOME/.bashrc"
fi

