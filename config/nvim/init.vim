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
set showtabline=1               " Show tab bar conditionally
set laststatus=2                " Always show status bar
set noshowmode                  " Hide mode (shown in powerline status bar)
set ignorecase                  " Use case insensitive searches by default
set smartcase                   " Use case sensitive search when uppercase used
set incsearch                   " Jump to search strings while typing
set hlsearch                    " Highlight search results
set spell                       " Enable spell checking

" Use 4 spaces instead of a tab
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Live dangerously
set nobackup
set nowritebackup
set noswapfile

" Create splits to the right (vertical) or to the bottom (horizontal)
set splitbelow
set splitright

" Don't auto-insert EOL
set nofixeol

" Use SPACE for leader key
let mapleader = " "

" Use ENTER to write files, and SPACE-SPACE to clear search highlighting
nmap <CR> :write<CR>
nmap <Leader><Leader> :nohlsearch<CR>:<Backspace>

" Add keyboard shortcuts for navigating splits
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Move all temporary files to single directory
if !isdirectory($HOME . '/.vimbkp')
  call mkdir($HOME . '/.vimbkp')
endif
set directory=~/.vimbkp//
set backupdir=~/.vimbkp//

" Ignore Ctrl-C
inoremap <c-c> <nop>

" Add keyboard shortcuts for moving between tabs
map <S-tab> <esc>:tabprevious<CR>
map <tab> <esc>:tabnext<CR>

" Install plugins
call plug#begin('~/.config/nvim/plugged')
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'zchee/deoplete-jedi'
Plug 'neomake/neomake', { 'on': 'Neomake' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'danro/rename.vim'
call plug#end()

" Set Python paths
let g:python3_host_prog = '/usr/bin/python3.5'
let g:python_host_prog = '/usr/bin/python2.7'

" Enable deoplete on startup
let g:deoplete#enable_at_startup = 1

" Configure CtrlP plugin
let g:ctrlp_map = '<Leader>t'
let g:ctrlp_user_command = 'ag --nogroup --nobreak --noheading --nocolor -g "" %s '
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 1

" Use one of my favorite color schemes if available
syntax on
try
  let g:solarized_termtrans=1
  set t_Co=16
  set background=light
  colorscheme solarized
catch
  silent! colorscheme desert
endtry

" Run Neomake for buffer opens/writes
autocmd! BufWritePost,BufEnter * Neomake

" Toggle hiding of decorations on Shift-H
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all == 0
        let s:hidden_all = 1
        set noruler
        set laststatus=0
        set noshowcmd
        set showtabline=0
        sign unplace *
    else
        let s:hidden_all = 0
        set ruler
        set laststatus=2
        set showcmd
        set showtabline=1
        Neomake
    endif
endfunction
nnoremap <S-h> :call ToggleHiddenAll()<CR>:<Backspace>
