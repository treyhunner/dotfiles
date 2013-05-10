" Manage runtime path with pathogen (if available)
silent! call pathogen#infect()

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
set laststatus=2                " Always show status bar
set noshowmode                  " Hide mode (shown in powerline status bar)
set ignorecase                  " Use case insensitive searches by default
set smartcase                   " Use case sensitive search when uppercase used
set incsearch                   " Jump to search strings while typing
set hlsearch                    " Highlight search results

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

" Move all temporary files to single directory
if !isdirectory($HOME . '/.vimbkp')
  call mkdir($HOME . '/.vimbkp')
endif
set directory=~/.vimbkp//
set backupdir=~/.vimbkp//

if has("autocmd")
  " Enable filetype-aware indentation and syntax highlighting rules
  filetype plugin indent on

  " Disable visual and audible bells
  set noerrorbells visualbell t_vb=
  autocmd GUIEnter * set visualbell t_vb=
endif

" Highlight tabs and trailing whitespace automatically
autocmd BufNewFile,BufReadPost,FilterReadPost,FileReadPost,Syntax * SpaceHi

let mapleader = " "
nmap <CR> :write<CR>
nmap <Leader><Leader> :nohlsearch<CR>:<Backspace>

" Syntastic options
let g:syntastic_check_on_open=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_python_checker_args = "--max-line-length=80"
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['python', 'javascript'],
                           \ 'passive_filetypes': ['html'] }

" Python Mode options
let g:pymode_lint = 0
let g:pymode_folding = 0
let g:pymode_utils_whitespaces = 0
let g:pymode_rope_goto_def_newwin = "new"

" Jedi options
let g:jedi#show_function_definition = "0"

" Hide Python binaries and swap files
let g:netrw_list_hide = '.py[co]$,.swp$,\(^\|\s\s\)\zs\.\S\+'
set wildignore=*.swp,*.bak,*.pyc,*.class

" vimux shortcuts
map <Leader>vp :VimuxPromptCommand<CR>
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vi :VimuxInspectRunner<CR>
map <Leader>vq :VimuxCloseRunner<CR>
map <Leader>vx :VimuxClosePanes<CR>
let g:VimuxUseNearestPane = 1
let g:VimuxHeight = "5"

command! Gpull :call VimuxRunCommand("git pull")
command! Gpush :call VimuxRunCommand("git push")
command! Gtop :e `git rev-parse --show-toplevel`

" Add keyboard shortcuts for moving between tabs
map <S-tab> <esc>:tabprevious<CR>
map <tab> <esc>:tabnext<CR>
