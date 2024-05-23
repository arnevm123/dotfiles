" syntax
syntax on
" filetype
filetype on
" Enable filetype plugins
filetype plugin on
filetype indent on
" base
set nocompatible                " don't bother with vi compatibility
set autoread                    " reload files when changed on disk, i.e. via `git checkout`
set nobackup                    " do not keep a backup file
" movement
set scrolloff=7                 " keep 7 lines when scrolling
" show
set number                      " show line numbers
set nowrap
" search
set hlsearch                    " highlight searches
set incsearch                   " do incremental searching, search as you type
set ignorecase                  " ignore case when searching
set smartcase                   " no ignorecase if Uppercase char present
" tab
set expandtab                   " expand tabs to spaces
set smarttab
set shiftround
" indent
set autoindent smartindent shiftround
set shiftwidth=4
set tabstop=4
set softtabstop=4                " insert mode tab and backspace use 4 spaces
"Keep search pattern at the center of the screen
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
"Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv
" y$ -> Y Make Y behave like other capitals
map Y y$
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
