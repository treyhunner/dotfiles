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
set ignorecase                  " Use case insensitive searches by default
set smartcase                   " Use case sensitive search when uppercase used
set incsearch                   " Jump to search strings while typing
set hlsearch                    " Highlight search results
set spell                       " Enable spell checking
set formatoptions-=t            " Don't automatically wrap text while typing

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
let maplocalleader = "\\"

" Use ENTER to write files, and SPACE-SPACE to clear search highlighting
nmap <CR> :write<CR>
nmap <Leader><Leader> :nohlsearch<CR>:<Backspace>

" Add keyboard shortcuts for navigating splits
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg
nnoremap  <leader>y  "+y

set pastetoggle=<F2>

" Add keyboard shortcuts for moving between tabs
map <S-tab> <esc>:tabprevious<CR>
map <tab> <esc>:tabnext<CR>

" Install plugins
call plug#begin('~/.config/nvim/plugged')
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'dense-analysis/ale'  " Asynchronous linting
Plug 'ctrlpvim/ctrlp.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'Carpetsmoker/auto_mkdir2.vim'
call plug#end()

:nnoremap <Leader>w :Bdelete<CR>

" Set Python paths
let g:python_host_prog = '/home/trey/.virtualenvs/neovim/bin/python'
let g:python3_host_prog = '/home/trey/.virtualenvs/neovim/bin/python'

" Vim surround extensions
" https://github.com/tpope/vim-surround/issues/213
 autocmd FileType markdown let b:surround_45 = "```\n\r\n```"
 autocmd FileType python let b:surround_45 = "\"\"\"\n\r\n\"\"\""

" Configure CtrlP plugin
let g:ctrlp_map = '<Leader>t'
let g:ctrlp_user_command = 'ag --nogroup --nobreak --noheading --nocolor -g "" %s '
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 1

" Configure riv plugin
let g:riv_disable_folding = 1
let g:riv_ignored_maps = '<CR>, <KEnter>'
let g:riv_ignored_imaps = "<Tab>, <S-Tab>"
let g:riv_ignored_nmaps = "<Tab>, <S-Tab>"

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

" Check Python files with flake8 and pylint.
let g:ale_linters = {'python': ['ruff', 'flake8']}
" Fix Python files with black
let g:ale_fixers = {'python': ['ruff', 'ruff_format', 'black']}
let g:ale_fix_on_save = 1
let g:ale_set_highlights = 0
let g:ale_virtualtext_cursor = 0

function! SuperHide()
    set nonumber
    highlight EndOfBuffer ctermfg=white ctermbg=white
endfunction


let s:fancy_features = 1
function! ToggleFancyFeatures()
    if s:fancy_features == 1
        let s:fancy_features = 0
        ALEReset
        let g:ale_enabled = 0
        let g:ale_fix_on_save = 0
        set textwidth=0
        set nospell
    else
        let s:fancy_features = 1
        let g:ale_enabled = 1
        let g:ale_fix_on_save = 1
        set textwidth=79
        set spell
    endif
endfunction

" ENABLE WHEN TEACHING
" let g:ale_enabled = 0
" let g:ale_fix_on_save = 0
" set nospell

" Toggle hiding of decorations on Shift-H
let s:hidden_all = 0
function! ToggleHiddenAll()
    call ToggleFancyFeatures()
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
    endif
endfunction
nnoremap <S-h> :call ToggleHiddenAll()<CR>:<Backspace>

augroup nvim_term
  au!
  au TermOpen * startinsert
  au TermClose * stopinsert
augroup END

augroup cmdline
    autocmd!
    autocmd CmdlineLeave : echo ''
augroup end
