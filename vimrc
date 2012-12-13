" Manage runtime path with pathogen (if available)
silent! call pathogen#infect()

set autochdir                   " Change directory to the current working file
set autoindent                  " Enable auto indentation
set ruler                       " Show line and column numbers
set showcmd                     " Show command in status line
set nrformats=                  " Increment numbers in decimal only
set mouse=a                     " Enable mouse support in terminal
set wildmode=longest,list       " Smart tab completion from command line
set cpoptions=aABceFs           " Set some reasonable vi-compatible behavior
set backspace=indent,eol,start  " Allow backspace over indentation and newlines
set guioptions=agi              " Set gVim guioptions (no toolbar or scrollbar)
set number                      " Turn on line numbers
set showtabline=2               " Always show tab bar

" Use one of my favorite color schemes if available
syntax on
try
  set background=light
  colorscheme solarized
catch
  silent! colorscheme desert
endtry

" Use 4 spaces instead of a tab
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Create splits to the right (vertical) or to the bottom (horizontal)
set splitbelow
set splitright

" Move all temporary files to single directory
set directory=~/.vimbkp//
set backupdir=~/.vimbkp//

if has("autocmd")
  " Enable filetype-aware indentation and syntax highlighting rules
  filetype plugin indent on

  " Disable visual and audible bells
  set noerrorbells visualbell t_vb=
  autocmd GUIEnter * set visualbell t_vb=
endif

