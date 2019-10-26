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

au InsertEnter * set nocursorline
au InsertLeave * set cursorline

highlight LineNr ctermfg=grey
highlight CursorLineNR ctermbg=DarkGray ctermfg=None
highlight CursorLine ctermbg=DarkGray ctermfg=None
