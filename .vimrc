" Behavior
    set nocompatible
    filetype off
    set nobackup
    set noswapfile
    set history=1000                " remember more commands and search history
    set undolevels=1000             " use many muchos levels of undo

" UX
    set number                      " Show line numbers
    set nostartofline               " Don’t reset cursor to start of line when moving around.
    set ruler                       " Show the cursor position
    set showmode                    " Show the current mode
    set clipboard=unnamed
    set backspace=indent,eol,start
    set noeol                       " Don’t add empty newlines at the end of files
  " set t_Co=256                    " Set 256 colors

" Encoding
    set fileencoding=utf-8          " Use UTF-8 without BOM
    set encoding=utf-8 nobomb

" Search
    set ignorecase                  " Ignore case of searches
    set incsearch
    set hlsearch                    " Highlight searches

" Ident
    set tabstop=2
    set shiftwidth=2
    set smarttab
    set expandtab
    set autoindent
    set smartindent

" Bundle
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

" Extend vim
    Bundle 'gmarik/vundle'
    Bundle 'altercation/vim-colors-solarized'
    Bundle 'scrooloose/nerdtree'
    Bundle 'kien/ctrlp.vim'
    Bundle 'mileszs/ack.vim'

" Autocomplite
    Bundle 'ervandew/supertab'
  " Bundle 'Rip-Rip/clang_complete'

" Snipmate
    Bundle "MarcWeber/vim-addon-mw-utils"
    Bundle "tomtom/tlib_vim"
    Bundle "garbas/vim-snipmate"
    Bundle "honza/vim-snippets"

" Linting
    Bundle 'scrooloose/syntastic'

" Syntax support
    Bundle 'kchmck/vim-coffee-script'
    Bundle 'digitaltoad/vim-jade'
    Bundle 'tpope/vim-haml'
    Bundle 'plasticboy/vim-markdown'


:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

filetype plugin indent on     " required!
let g:syntastic_javascript_checkers = ['jshint']

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeHighlightCursorline=0

" save by ctrl-s
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a

syntax enable
set background=dark
colorscheme solarized
