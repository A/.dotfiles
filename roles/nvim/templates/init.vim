" {{ ansible_managed }}
filetype plugin on

let mapleader = " "
set nobackup
set noswapfile
set nowrap
set number
set nostartofline
set clipboard=unnamed
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

" Remember folding through sessions
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview
au InsertEnter * set nocursorline
au InsertLeave * set cursorline

set updatetime=750


" PLUGINS:

let plug_install = 0
let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
if !filereadable(autoload_plug_path)
  silent exe '!curl -fL --create-dirs -o ' . autoload_plug_path .
    \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  execute 'source ' . fnameescape(autoload_plug_path)
  let plug_install = 1
endif
unlet autoload_plug_path

call plug#begin(stdpath('config') . '/plugins')

{% for plugin in nvim_plugins %}
Plug '{{ plugin.name }}'{% if plugin.do is defined %}, {'do': '{{ plugin.do }}' }{% endif %}

{% endfor %}

call plug#end()

if plug_install
  PlugInstall --sync
endif
unlet plug_install

" END PLUGINS


" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif


nmap <silent> gF :vsp<CR>gf
noremap <leader>fs :Vgrep

