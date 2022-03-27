"
" srg's vimrc
"

" Standard Config
set autoread                   " Reload externally-modified files
set backspace=indent,eol,start " Backspace over indent, eol, start
set colorcolumn=160            " Mark long lines
set encoding=utf-8
set errorbells                 " Beep or flash screen on errors
set formatoptions+=j           " Delete comment character when joining commented lines
set hidden                     " Allow switching away from changed buffers without writing
set history=100                " History of :commands and search patterns
set ignorecase                 " In search patterns
set noincsearch                " Never show search results incrementally
set laststatus=2               " Always show status line
set matchtime=10               " Tenths of a second to show matching brace
set nomodeline                 " Don't process modelines
set number                     " Show line numbers
set ruler                      " Show row and column ruler information
set scrolloff=10               " Number of lines of context above/below cursor
set secure                     " Disable autocmd/write in .vimrc
set shortmess=ilnrx            " Don't abbrevate most things
set showbreak=++               " Wrap-broken line prefix
set showcmd                    " Show incomplete/pending commands
set showmatch                  " Highlight matching brace
set showtabline=2              " Always show the tab bar
set smartcase                  " If search has upper case, ignore ignorecase
set nospell
set undolevels=200
set visualbell                 " Flash screen (no beeping)
set wildignore=*/.git/*,*/.svn/*,*/.DS_Store
set wildmenu                   " Enable tab-completion menu

" Display
set background=dark            " Terminal background color for syntax colors
set foldcolumn=1
set hlsearch                   " Highlight all search results
set cmdheight=1
set mouse=                     " Don't use the mouse
set linebreak                  " Break lines at words
set list                       " Show invisibles
" set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\ 
set listchars=trail:·,precedes:«,extends:»,tab:▸\ 

syntax enable
set hlsearch
set fileformats=unix,dos,mac   " In order
filetype on                    " Try to recognize the file type (and set options)
filetype plugin on
filetype indent on

" Tab Chars
set autoindent                 " Auto-indent new lines
set noexpandtab                " Don't expand tabs into spaces
set shiftwidth=4               " Width of an indent in characters
set smartindent                " Auto-indent
set smarttab                   " Auto-tab
set softtabstop=4              " Number of spaces per tab; Same as tabstop
set tabstop=4                  " Width of an actual tab character

" Dedicated swap dir, backup dir, and undo dir.
" mkdir -vp ~/.vim/swapdir ~/.vim/backupdir ~/.vim/undodir
set directory=~/.vim/swapdir// " The double slash is intentional; see :help directory
set backup                     " Keep backups around
set backupcopy=yes             " Make backups by copying original
set backupdir=~/.vim/backupdir/
set writebackup                " Make a backup before overwriting a file
set undodir=~/.vim/undodir/
set undofile

" netrw file browser.
let g:netrw_banner=0           " Don't show the top banner
let g:netrw_browse_split=3     " Open files in a new tab
let g:netrw_keepdir=0          " Sync the current dir and the browsing dir
let g:netrw_liststyle=3
let g:netrw_winsize=30         " Percent width of window for splits
