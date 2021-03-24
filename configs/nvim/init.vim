filetype plugin on

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
set noautoindent
set tabstop=2
set nosmartindent
set smarttab
set shiftwidth=2
set encoding=utf-8 nobomb
set fileencoding=utf-8
set colorcolumn=120
set scrolloff=8
set list
set lcs=eol:·
set cursorline
set showtabline=0
set splitbelow
set splitright
set wildignore+=package-lock.json,yarn.lock
set path+=src/**,packages/**/src/** " file search path
set spelllang=en_us,ru
set updatetime=750
set laststatus=2
set completeopt-=preview

runtime! config.d/*.vim

colorscheme trash-polka
let g:airline_theme='trashpolka'
