" vimrc

set modelines=5
set nrformats-=octal   " Remove octal numbering
set nocompatible       " Use vim defaults instead of 100% vi compatibility
set autoindent         " Auto indent new lines
set smartindent        " Make autoindent smarter
set smarttab           " Proper indenting with <Tab>
set autowrite          " Automatically save before commands like :next and :make
set backspace=indent,eol,start " more powerful backspacing
"set cursorline         " Highlight current line
set hidden             " Hide buffers when they are abandoned
set history=50         " keep 50 lines of command line history
set ignorecase         " Wait for smartcase...
set smartcase          " Do smart case matching when searching
set incsearch          " Incremental search
set hlsearch           " Highlight search results
set list               " Show invisibles
set listchars=tab:▸-   " Set tab icon
"set mouse=a            " Enable mouse usage (all modes) in terminals
set number             " Enable line numbers
set relativenumber     " Relative numbers
set ruler              " show the cursor position all the time
set scrolloff=3        " Never lean to the top or bottom of the window
set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set softtabstop=2 tabstop=2 shiftwidth=2 expandtab " Default whitespace settings
set viminfo='20,\"50   " read/write a .viminfo file, don't store more than 50 lines of registers
set wildmenu           " Enhanced command-line completion.
set wildmode=list:longest " Show all alternatives and complete furtherest possible.
set completeopt=menuone,longest,preview " Better completion menu

if version >= 703
  " Vertical line on column 120
  set colorcolumn=120
  " Persistent undo history
  set undofile
  set undodir=~/.vim/backup
endif

" Use syntax highlight
if !exists("syntax_on")
  syntax on
endif

" Suffixes that get lower priority when doing tab completion for filenames
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pyo,.pyc,.rbc

" Extra white space
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWritePre * :%s/\s\+$//e "clean extra whitespace on write

" Retore last edit location when opening a file
autocmd BufReadPost * if line("'\"") > 0 && line ("'\"") <= line("$") | exe "normal g'\"" | endif

" Highlight space errors in C/C++ source files
let c_space_errors=1

" Disable auto-comment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Always jump to the top of commit messages
au BufReadPost svn-commit*.tmp exe "normal! gg"
au BufReadPost COMMIT_EDITMSG* exe "normal! gg"

" Set filetypes
au BufRead,BufNewFile *.json set filetype=json

" Load plugins
filetype plugin indent on

" Pathogen
execute pathogen#infect()

" Solarized
"colorscheme solarized
"set background=dark

" Airline
set laststatus=2
let g:airline_powerline_fonts=1

" Workaround for leaving insert mode delay with statusline active
if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

" Signify
let g:signify_vcs_list=['git','svn']

" Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_id_checkers = 1
" let g:syntastic_quiet_messages = { "type": "style" }

" Supertab
let g:SuperTabDefaultCompletionType = "context"

" JavaScript libraries syntax
let g:used_javascript_libs = 'angularjs'

" Explore
let g:netrw_liststyle=3

