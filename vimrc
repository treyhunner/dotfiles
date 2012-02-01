syntax on

" Manage runtime path with pathogen (if available)
silent! call pathogen#infect()

" Use one of my favorite color schemes if available
silent! colorscheme desert
if has('gui_running')
  silent! colorscheme jellybeans
  silent! colorscheme xoria256
  silent! colorscheme molokai
  silent! colorscheme solarized
endif

set autochdir                   " Change directory to the current working file
set autoindent                  " Enable auto indentation
set ruler                       " Show line and column numbers
set showcmd                     " Show command in status line
set nrformats=                  " Increment numbers in decimal only
set mouse=a                     " Enable mouse support in terminal
set wildmode=longest,list       " Smart tab completion from command line
set cpoptions=aABceFs           " Set some reasonable vi-compatible behavior
set backspace=indent,eol,start  " Allow backspace over indentation and newlines
set guioptions=agim             " Set gVim guioptions (no toolbar or scrollbar)

" Use 4 spaces instead of a tab
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Move all temporary files to single directory
set directory=~/.vimbkp//
set backupdir=~/.vimbkp//

" Enable filetype-aware indentation and syntax highlighting rules
if has("autocmd")
  filetype plugin indent on
endif

