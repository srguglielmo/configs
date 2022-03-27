# (Shebang intentionally omitted)
# shellcheck shell=zsh
#
# srg's ~/.zshrc
# Run by interactive shells only (both login and not).
#

############
# ENV VARS #
############
# Env vars must be first because commands below use them.

export EDITOR="vim -e"                                     # Ex-mode
export GPG_TTY=$(tty)                                      # For gpg-agent
export LESS='--ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS'
export LESSHISTFILE=/dev/null
export LESSSECURE=1
#export LESS_TERMCAP_mb=$(printf "\e[1;31m")
#export LESS_TERMCAP_md=$(printf "\e[1;31m")
#export LESS_TERMCAP_me=$(printf "\e[0m")
#export LESS_TERMCAP_se=$(printf "\e[0m")
#export LESS_TERMCAP_so=$(printf "\e[1;44;33m")
#export LESS_TERMCAP_ue=$(printf "\e[0m")
#export LESS_TERMCAP_us=$(printf "\e[1;32m")
export PAGER=less
export VISUAL=vim

###########
# ALIASES #
###########
# Note: Aliases stack.

# For MacOS.
if [ "$(uname)" = "Darwin" ]; then
	# Make homebrew stop automatically running 'cleanup' after 'upgrade's.
	export HOMEBREW_NO_INSTALL_CLEANUP=true

	# Use GNU utils if they exist as separate binaries.
	(( $+commands[gcp] ))       && alias cp='gcp -ipv'
	(( $+commands[gdd] ))       && alias dd='gdd'
	(( $+commands[gfind] ))     && alias find='gfind'
	(( $+commands[ggrep] ))     && alias grep='ggrep --color=auto'
	(( $+commands[gln] ))       && alias ln='gln'
	(( $+commands[gls] ))       && alias l="gls -AFhl --color --time-style='+%Y-%m-%d'"
	(( $+commands[gls] ))       && alias ls='gls -AFh --color'
	(( $+commands[gmv] ))       && alias mv='gmv -iv'
	(( $+commands[greadlink] )) && alias readlink='greadlink'
	(( $+commands[grm] ))       && alias rm='grm -Iv --one-file-system'
	(( $+commands[gsed] ))      && alias sed='gsed'
	(( $+commands[gsort] ))     && alias sort='gsort'
	(( $+commands[gtar] ))      && alias tar='gtar'
	(( $+commands[gtr] ))       && alias tr='gtr'
	(( $+commands[gunits] ))    && alias units='gunits'
	(( $+commands[gxargs] ))    && alias xargs='gxargs'
else
	# Linux only.
	alias cp='cp -ipv'
	alias grep='grep --color=auto'
	alias l="ls -aFhl --color --time-style='+%Y-%m-%d'"
	alias ls='ls -aFh --color'
	alias mv='mv -iv'
	alias rm='rm -Iv --one-file-system'
fi

# All-OS aliases.
alias dqr='diff -qr --exclude=".git"'
#alias dv='dirs -v'
alias gs='git status'
alias gfs='git fetch --verbose --all; git status; git --no-pager stash list'
alias sudo='printf "Stop using sudo!\n"'                   # OpenBSD's `doas` is better
alias vi='vim'

# Global aliases.
alias -g G="| grep"
alias -g L="| $PAGER"

# Suffix aliases ("text.NAME" -> "VALUE text.NAME").
#alias -s css=$VISUAL
#alias -s html=$VISUAL
#alias -s js=$VISUAL
#alias -s log=$PAGER
#alias -s php=$VISUAL
#alias -s txt=$VISUAL

# TODO: What is setting these?
unalias run-help 2>/dev/null
unalias which-command 2>/dev/null

#############
# FUNCTIONS #
#############

# Functions to autoload from $fpath.
autoload -Uz compinit                                      # The "new" completion system
autoload -Uz down-line-or-beginning-search                 # Contrib; Match history down based on prefix
autoload -Uz up-line-or-beginning-search                   # Contrib; Match history up based on prefix
autoload -Uz vcs_info                                      # Contrib; version control info

# Custom handling of unknown commands.
function command_not_found_handler {
	printf "zsh: command not found: %s\n" "$1"
	return 127
}

# Function that sets the right prompt based on the current zle vi mode
# and the git status/branch. This is called from my-zle-line-init()
# and my-zle-keymap-select().
function indicate-my-zle-mode {
	RPS1='${vcs_info_msg_0_} '                             # zsh's vcs_info

	RPS1+='%F{251}['

	# Print the vi mode that zle is in.
	if [ $KEYMAP = "main" ]; then                          # "main" is insert mode
		RPS1+='%F{040}INS'
	elif [ $KEYMAP = "vicmd" ]; then
		RPS1+='%K{088}%F{227}%BCMD%b%k'
	elif [ $KEYMAP = "viopp" ]; then
		RPS1+='%K{088}%F{227}%BOPP%b%k'
	elif [ $KEYMAP = "visual" ]; then
		RPS1+='%K{088}%F{227}%BVIS%b%k'
	else
		RPS1+="%K{088}%F{227}%BERR/$KEYMAP%b%k"
	fi

	RPS1+='%F{251}]%f'

	zle reset-prompt                                       # Redraw the prompts
}

# Set the zle mode and preserve the exit status of the previous command.
function my-zle-keymap-select {
	# Set RPS1.
	indicate-my-zle-mode

	# Return the last program's exit code for use in in $PS1.
	function {
		return $__prompt_status
	}
}

# Since $? is used in PS1, the exit status of the last executed
# command is preserved in to a global variable.
function my-zle-line-init {
	# Set RPS1.
	indicate-my-zle-mode

	typeset -g __prompt_status="$?"
}

# Gather the git info just before each prompt.
function precmd {
	vcs_info
}

# Custom function to handle command history.
# This defangs "dangerous" commands by recording
# them in history prefixed with a comment (#).
#function zshaddhistory() {
#	if [[ $1 =~ "^ " ]]; then
#		# This will respect HIST_IGNORE_SPACE.
#		return 0
#	elif [[ $1 =~ "cp\ *|mv\ *|rm\ *|cat\ *\>|pv\ *|dd\ *" ]]; then
#		1="# $1"
#	fi
#
#	# Write to usual history location.
#	print -sr -- ${1%%$'\n'}
#
#	# Instruct the shell itself not to save the history (again).
#	return 1
#}

################
# KEY BINDINGS #
################

bindkey -v                                                 # Vi style in zle
bindkey '	' complete-word                                # Use the _expand completer for tabs

# Bind arrow up/down to the contrib functions to match history based
# on the current line prefix (autoloaded above).
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

###########
# MODULES #
###########

# Provides extensions to completion listings.
# Ability to highlight matches, ability to scoll, and different styles.
zmodload zsh/complist

# Provides `strftime` builtin and a few read-only time-related variables.
zmodload zsh/datetime

# Useful in recovery/emergency situations.
#zmodload zsh/files

# Provide access to the 'command' array (the internal
# hash table of external commands).
zmodload zsh/parameter

# Scheduled commands.
#zmodload zsh/sched

# Provides `zstat` (but don't override `stat` too).
zmodload -F zsh/stat b:zstat

# Create TCP connections with `ztcp`
# and FTP connections with `zftp`.
#zmodload zsh/net/tcp
#zmodload zsh/zftp

# Zsh Line Editor (zle).
zmodload zsh/zle
zmodload zsh/zleparameter

# Provides `zstyle` and few other builtins.
zmodload zsh/zutil

###########
# OPTIONS #
###########

# Directory.
setopt AUTO_CD                                             # Change dir even if I forget to type `cd`
setopt AUTO_PUSHD                                          # Add dirs to the directory stack automatically
setopt PUSHD_IGNORE_DUPS                                   # Ignore dupes in the directory stack
#setopt PUSHD_MINUS                                        # Swap the meaning of + and -

# Completion.
#setopt ALWAYS_TO_END                                      # Move cursor to end, even when completing in a word
setopt BASH_AUTO_LIST                                      # Show completion menu on 2nd tab
setopt COMPLETE_ALIASES
setopt COMPLETE_IN_WORD                                    # Must be set for the _prefix completer
#setopt GLOB_COMPLETE                                      # Customized completion is defined below

# Expansion/Globbing.
unsetopt CASE_GLOB                                         # Make globbing case-insensitive
setopt MARK_DIRS                                           # Append / to dirs resulting from globbing
setopt NUMERIC_GLOB_SORT                                   # Sort numeric filenames numerically
setopt REMATCH_PCRE                                        # =~ uses zsh/pcre (else uses the sytem ereg libraries)
#unsetopt UNSET                                            # zsh-syntax-highlighting complains with this unset
#setopt WARN_CREATE_GLOBAL                                 # Something complains with this set
#setopt WARN_NESTED_VAR                                    # vcs_info complains with this set

# History.
#unsetopt BANG_HIST                                        # History references using !
setopt HIST_FCNTL_LOCK                                     # Lock the history file when writing
setopt HIST_IGNORE_ALL_DUPS                                # Remove dupes when writing
setopt HIST_IGNORE_SPACE                                   # Ignore commands with spaces prepended
setopt HIST_LEX_WORDS                                      # Be accurate when reading in a history file
setopt HIST_NO_FUNCTIONS                                   # Don't record functions definitions
setopt HIST_NO_STORE                                       # Department of Redundancy Department
setopt HIST_REDUCE_BLANKS                                  # Don't record blank commands
setopt HIST_SAVE_NO_DUPS                                   # Don't save any dupes when writing file
setopt HIST_VERIFY                                         # Probably a good idea
setopt INC_APPEND_HISTORY                                  # Append to history immediately
unsetopt SHARE_HISTORY                                     # Not even in ksh mode

# Input/Output
unsetopt CLOBBER                                           # Don't let > and >> clobber files (use >! or >>! instead)
unsetopt FLOW_CONTROL                                      # Disable ctrl+s and ctrl+q
setopt HASH_EXECUTABLES_ONLY                               # Only "cache" the path to to exec files
setopt INTERACTIVE_COMMENTS                                # Allow comments on interactive sessions
unsetopt PATH_SCRIPT                                       # Don't search in path for a passed script argument
unsetopt RM_STAR_SILENT                                    # Not even in ksh/sh emulation mode

# Job control
setopt LONG_LIST_JOBS                                      # Long listing by default

# Prompt
setopt PROMPT_SUBST                                        # Required for vcs_info in prompt

# Scripts/functions
setopt C_BASES                                             # Use 0xFF for hex numbers instead of 16#FF
setopt LOCAL_LOOPS                                         # Strict usage of break/continue
unsetopt MULTI_FUNC_DEF                                    # Don't allow func definitions with multiple names
#unsetopt MULTIOS                                          # Don't automatically add extra tees and pipes
setopt PIPE_FAIL                                           # Return the exit status of the rightmost non-zero
#setopt SOURCE_TRACE                                       # Display names of files as they're sourced

# ZLE
setopt COMBINING_CHARS
unsetopt SINGLE_LINE_ZLE                                   # Not even in KSH emulation mode

##########
# STYLES #
##########

# https://zsh.sourceforge.io/Doc/Release/Completion-System.html
# Style syntax:
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# Global styles.
zstyle ':completion:*:*:*:*:*' completer _expand _expand_alias _complete _match _prefix _history _correct
zstyle ':completion:*:*:*:*:*' expand prefix suffix
zstyle ':completion:*:*:*:*:*' group-name ''               # Display all all types of matches separately
zstyle ':completion:*:*:*:*:*' insert-unambiguous true
zstyle ':completion:*:*:*:*:*' list-colors ''              # Colored listings (req group-name='')
zstyle ':completion:*:*:*:*:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*:*:*:*:*' list-suffixes true
zstyle ':completion:*:*:*:*:*' menu select=5               # Use a menu (with arrow keys) for >=5 matches
zstyle ':completion:*:*:*:*:*' rehash true                 # Always rehash; there's a speed penalty though...
zstyle ':completion:*:*:*:*:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*:*:*:*:*' use-cache true              # ~/.zcompcache
zstyle ':completion:*:*:*:*:*' verbose true

# Styles for specific completers.
zstyle ':completion:*:correct:*:*:*' max-errors 2 not-numeric
zstyle ':completion:*:history:*:*:*' range 20:5

# Styles for specific commands.
zstyle ':completion:*:*:cd:*:*' ignore-parents parent pwd

# Git info.
zstyle ':vcs_info:*' actionformats '%F{251}[%F{227}%K{088}%b/%a%k%F{251}]%f'
zstyle ':vcs_info:*' branchformat '%b'                     # %b
zstyle ':vcs_info:*' check-for-changes true                # Enable use of %c and %u
zstyle ':vcs_info:*' enable git                            # Only use git (not svn, etc)
zstyle ':vcs_info:*' formats '%F{251}[%F{040}%c%u%b%F{251}]%f'
zstyle ':vcs_info:*' stagedstr '%F{057}Stg '               # %c
zstyle ':vcs_info:*' unstagedstr '%F{172}Unstg '           # %u

#############
# VARIABLES #
#############
# Lowercase variables are arrays.

# ZSH vars.
cdpath=(. ~/Code)                                          # PATH, but for cd
#CORRECT_IGNORE=                                           # Ignore pattern for spell correction
#CORRECT_IGNORE_FILE=                                      # Ignore pattern for spell correction on filenames
DIRSTACKSIZE=20                                            # Directory history size
#fignore=()                                                # File suffixes to ignore during completion
HISTFILE=~/.zhistory
HISTORY_IGNORE="(l|ls|cd|pwd|exit)"                        # Ignore pattern for history entries
HISTSIZE=10000
#KEYTIMEOUT=                                               # In hundredths of a second
LANG=en_US.UTF-8
path=()
path+=(~/.local/bin ~/bin ~/Code/composer/vendor/bin ~/go/bin)
path+=(/usr/local/bin)                                     # System local
path+=(/usr/bin)                                           # System

# The main prompt.
PS1="%F{057}%n%F{251}@%F{172}%M%f "                        # user@host
PS1+="%F{251}%~%f"                                         # directory
PS1+=$'\n'                                                 # newline
PS1+='%(?.'                                                # If exit code is 0
	#PS1+='(%?%)'                                          #   just display the exit code, no color
PS1+='.'                                                   # else
	PS1+='%K{088}%F{227}%B'                                #   start color and bold
	PS1+='(%?%)'                                           #   print exit code
	PS1+='%b%f%k '                                         #   end bold and color
PS1+=')'                                                   # endif
PS1+="%F{040}%(2L.++.%#)%f "                               # If in subshell, print ++, else %#		FIXME

REPORTMEMORY=128                                           # Min size in MB to report
REPORTTIME=5                                               # Min seconds to report
RPS1=""                                                    # Set empty to display the KEYMAP in RPS1 for first prompt
SAVEHIST=5000
TIMEFMT='[%*E] [%U CPUusr] [%S CPUsys] [%MMiB Max]'
TMPPREFIX=/tmp/zsh
watch=(notme)

#######
# ZLE #
#######

# Create user defined widgets that use the above loaded widgets.
zle -N down-line-or-beginning-search
zle -N up-line-or-beginning-search

# zle-keymap-select is a widget that is executed every time KEYMAP changes
# while the line editor is active. $KEYMAP within the function is the new keymap.
# It's overriden with our own function. The old keymap is passed as the sole argument.
zle -N zle-keymap-select my-zle-keymap-select

# zle-line-init is a widget that is executed every time zle is
# started to read a new line of input. Override it with our own function.
zle -N zle-line-init my-zle-line-init

##################
# INITIALIZATION #
##################

# Execute the completion function (which was autoloaded above).
compinit

# Completions for AWS.
if (( ${+commands[aws_zsh_completer.sh]} )) && [[ -x $commands[aws_zsh_completer.sh] ]]; then
	source $commands[aws_zsh_completer.sh]
fi

# Completions for kubectl.
if (( ${+commands[kubectl]} )) && [[ -x $commands[kubectl] ]]; then
	source <($commands[kubectl] completion zsh)
fi

# Completions for pip.
if (( ${+commands[pip]} )) && [[ -x $commands[pip] ]]; then
	source <($commands[pip] completion --zsh)
fi

# Load zsh-syntax-highlighting (must be last).
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

	# Don't exhaust yourself.
	ZSH_HIGHLIGHT_MAXLENGTH=512

	# Array of highlighters to enable.
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root)

	ZSH_HIGHLIGHT_PATTERNS+=('rm -r' 'fg=white,bold,bg=red')
	ZSH_HIGHLIGHT_PATTERNS+=('rm -f' 'fg=white,bold,bg=red')
	ZSH_HIGHLIGHT_PATTERNS+=('rm -rf' 'fg=white,bold,bg=red')
	ZSH_HIGHLIGHT_PATTERNS+=('rm -fr' 'fg=white,bold,bg=red')

	typeset -A ZSH_HIGHLIGHT_STYLES

	# Bracket styles.
	ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=white,bold,bg=red'
	ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=red,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=yellow,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=magenta,bold'
	ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='bg=blue'

	# Comments default to black, which are invisible on a black terminal.
	ZSH_HIGHLIGHT_STYLES[comment]='fg=cyan'

	ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'

	ZSH_HIGHLIGHT_STYLES[root]='bg=red'
else
	echo "WARNING: Missing zsh-syntax-highlighting!"
fi
