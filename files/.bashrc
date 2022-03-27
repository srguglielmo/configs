# (Shebang intentionally omitted)
# shellcheck shell=bash
#
# srg's ~/.bashrc.
# Non-login interactive shells.
# This file is sourced manually by ~/.bash_profile for interactive login shells.
#

# Set the prompt.
if [[ "$EUID" -eq 0 ]]; then
	PS1="\[$(tput setaf 1)$(tput bold)\][\u@\h] \w\n\$\[$(tput sgr0)\] "
else
	PS1="\[$(tput setaf 2)\][\u@\h] \w\n\$\[$(tput sgr0)\] "
fi
PS2="> "
PS3="> "
PS4="+ "

# Setup history.
HISTCONTROL="ignorespace:erasedups"
HISTSIZE=500
HISTFILESIZE=500
HISTFILE="$HOME/.bash_history"
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# Options.
shopt -s autocd
shopt -s checkjobs
shopt -s checkwinsize
shopt -s histappend

# Environment.
export EDITOR="vim"
export LANG="en_US.UTF-8"
export LESSHISTFILE="/dev/null"
export LESSSECURE=1
export PATH="/usr/local/bin:/usr/bin:/bin"
export VISUAL="vim"

# Aliases.
alias cp='cp -iv'
alias gfs='git fetch --verbose --all; git status; git --no-pager stash list'
alias gs='git status'
alias l='ls -aFhl --color --time-style="+%Y-%m-%d"'
alias mkdir='mkdir -v'
alias mv='mv -iv'
alias rm='rm -iv --one-file-system'
alias vi='vim'

# Completions.
if command -v kubectl 1>/dev/null; then
	source <(kubectl completion bash)
fi
