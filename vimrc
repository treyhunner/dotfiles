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
set showtabline=1               " Show tab bar conditionally
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

" Use SPACE for leader key
let mapleader = " "

" Use ENTER to write files, and SPACE-SPACE to clear search highlighting
nmap <CR> :write<CR>
nmap <Leader><Leader> :nohlsearch<CR>:<Backspace>

" Use lusty juggler for buffer management
let g:LustyJugglerKeyboardLayout = "dvorak"
nmap <c-b> :LustyJuggler<cr>
map <c-tab> <C-W>w
map <leader>w :Bclose<cr>

" Syntastic options
let g:syntastic_check_on_open=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': ['python', 'javascript'],
                           \ 'passive_filetypes': ['html'] }
let g:syntastic_python_checkers=['flake8']
let g:syntastic_auto_loc_list = 0

" Python Mode options
let g:pymode_lint = 0
let g:pymode_folding = 0
let g:pymode_utils_whitespaces = 0
let g:pymode_rope_goto_def_newwin = "new"
let g:pymode_rope = 0

let g:user_zen_settings = {
\  'html' : {
\    'empty_element_suffix': '>',
\  }
\}

" Jedi options
let g:jedi#show_function_definition = "0"
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0

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

nmap gh :GitGutterNextHunk<CR>
nmap gH :GitGutterPrevHunk<CR>

nmap <Leader>o :set paste!<CR>

" Add keyboard shortcuts for navigating splits
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Add keyboard shortcuts for moving between tabs
map <S-tab> <esc>:tabprevious<CR>
map <tab> <esc>:tabnext<CR>

let g:ctrlp_map = '<Leader>t'
let g:ctrlp_user_command = 'ag --nogroup --nobreak --noheading --nocolor -g "" %s '
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 1
