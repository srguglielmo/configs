alias	rm	"rm -i"
alias	l	"ls -aloh"
alias	genpass "apg -a 0 -n 10 -m 12 -x 32 -M SCNL -s"
alias	vi	vim
alias	g	grep

setenv	EDITOR	vim
setenv	PAGER	less
setenv	TOP	"-S -a -P -s1 -ocpu"
setenv	LESS	"--long-prompt --RAW-CONTROL-CHARS"
setenv	LESSHISTFILE	-
setenv	LESSSECURE	1

umask 0077

if ($?prompt) then
	set autolist = ambiguous
	set color
	set complete = enhance
	set history = 100
	set ignoreeof = 9
	set matchbeep = ambiguous
	set noding
	set padhour
	set printexitvalue
	set prompt = "%B%n%b@%B%M%b %~%# "
	set rmstar
	set symlinks = ignore
	if ( $?tcsh ) then
		bindkey -k up history-search-backward
		bindkey -k down history-search-forward
	endif
endif
