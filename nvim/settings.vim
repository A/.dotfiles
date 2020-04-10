let g:python_host_prog = '/usr/local/bin/python2.7'
let g:python2_host_prog = '/usr/local/bin/python2.7'
let g:python3_host_prog = '/usr/local/bin/python3.7'

" Behavior
set nobackup
set noswapfile
set nowrap
set number
set nostartofline
set clipboard=unnamedplus
set backspace=2
set mouse=a
set expandtab
set ignorecase
set autoindent
set tabstop=2
set smartindent
set smarttab
set shiftwidth=2
set encoding=utf-8 nobomb
set fileencoding=utf-8 " Use UTF-8 without BOM
set colorcolumn=120          " bad and extrabad line sizes
set scrolloff=8             " Start scrolling when we're 8 lines away from margins
set list              " show invisibles
set lcs=eol:· " Use the same symbols as TextMate for tabstops and EOLs
set cursorline
set showtabline=0
set splitbelow
set splitright

set path+=src/**,packages/**/src/**

au InsertEnter * set nocursorline
au InsertLeave * set cursorline

set updatetime=750

" Update colorscheme based on dark/light interface style
let g:airline_theme = 'trashpolka'
" let g:colorschemeDark  = 'trash-polka'
" let g:colorschemeLight = 'trash-polka-light'
" call SetBackgroundMode()
" call timer_start(3000, "SetBackgroundMode", {"repeat": -1})
