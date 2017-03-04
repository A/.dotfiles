" How to… What is… WTF? Just `:help keyword`

  set nocompatible
  set nobackup
  set noswapfile
  set noeb vb t_vb=           " disable error beeping
  set tildeop                 " use ~ as operator for text objects like `~iw`
  set nowrap                  " hate wrapping for tiny windows. It makes code absolute unreadable
  set number                  " Show line numbers
  set nostartofline           " Don’t reset cursor to start of line when moving around.
  set colorcolumn=80          " bad and extrabad line sizes
  set showmode                " Show the current mode
  set clipboard=unnamed       " use os x clipboard
  set backspace=2             " use c-w and c+u
  set showcmd                 " Display incomplete commands.
  :au InsertEnter * set cul   " Show cursor line in insert mode
  :au InsertLeave * set nocul " Hide cursor line in insert mode
  set scrolloff=8             " Start scrolling when we're 8 lines away from margins

  " Shortcuts for moving between tabs.
  noremap [ gT
  noremap ] gt

  " Disable <Arrow keys>
  inoremap <Up> <NOP>
  inoremap <Down> <NOP>
  inoremap <Left> <NOP>
  inoremap <Right> <NOP>
  noremap <Up> <NOP>
  noremap <Down> <NOP>
  noremap <Left> <NOP>
  noremap <Right> <NOP>

  " arrow key to navigate windows
  noremap <Down> <C-W>j
  noremap <Up> <C-W>k
  noremap <Left> <C-W>h
  noremap <Right> <C-W>l

  " Snippets
  nmap <f5> :tabedit ~/.vim/bundle/vim-snippets/snippets/<CR>

  com! FormatJSON %!python -m json.tool

  " Return to last edit position when opening files (You want this!)
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Remember info about open buffers on close
  set viminfo^=%

  fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
  endfun

  " Automatically clean trailing whitespaces on save
  autocmd BufWritePre *.* :call <SID>StripTrailingWhitespaces()

  " Encoding
  set encoding=utf-8 nobomb
  set fileencoding=utf-8 " Use UTF-8 without BOM

  " # Search
  set incsearch
  set ignorecase " Ignore case of searches
  set hlsearch   " Highlight searches

" # Ident
  set tabstop=2
  set shiftwidth=2
  set smarttab
  set expandtab
  set autoindent
  set smartindent
  set pastetoggle=<F2>  " to fix weird behawiour on paste, etc
  set list              " show invisibles
  set lcs=tab:▸\ ,eol:¬ " Use the same symbols as TextMate for tabstops and EOLs

" # Bundle
  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()

" # Timing
  " Bundle 'wakatime/vim-wakatime'

" # Extend vim
  " use russian layout the only in the insert mode
  " Bundle 'porqz/KeyboardLayoutSwitcher'
  " Bundle 'mattesgroeger/vim-bookmarks'
  " Bundle 'tpope/vim-surround'
  Bundle 'godlygeek/tabular'
    let mapleader=','
      if exists(":Tabularize")
        nmap <Leader>a= :Tabularize /=<CR>
        vmap <Leader>a= :Tabularize /=<CR>
        nmap <Leader>a: :Tabularize /:\zs<CR>
        vmap <Leader>a: :Tabularize /:\zs<CR>
      endif
  Bundle 'gmarik/vundle'
  Bundle 'shuvalov-anton/seoul256.vim'
    set background=dark
    colorscheme morning
  Bundle 'scrooloose/nerdtree'
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    map <C-n> :NERDTreeToggle<CR>
  " Bundle 'jistr/vim-nerdtree-tabs'
    let NERDTreeHighlightCursorline=0
    silent! map <F4> :NERDTreeFind<CR>
    let g:NERDTreeMapActivateNode="<F4>"
    let g:NERDTreeMapPreview="<F3>"
  Bundle 'kien/ctrlp.vim'
  Bundle 'mileszs/ack.vim'
  " Git goodies
  Bundle 'tpope/vim-fugitive'
  Bundle 'bling/vim-airline'
  Bundle 'vim-airline/vim-airline-themes'
    set laststatus=2                                  " vim-airline doesn't appear until I create a new split
    let g:airline_theme='lucius'                      " Colorscheme for airline
    let g:airline_left_sep = ''                       " Set custom left separator
    let g:airline_right_sep = ''                      " Set custom right separator
    let g:airline#extensions#tabline#enabled = 1      " Enable airline for tab-bar
    let g:airline#extensions#tabline#show_buffers = 0 " Don't display buffers in tab-bar with single tab
    let g:airline#extensions#tabline#fnamemod = ':t'  " Display only filename in tab
    let g:airline_section_y = ''                      " Don't display encoding
  Bundle 'Shougo/unite.vim'

" # Autocomplite
  Bundle 'ervandew/supertab'
  Bundle 'othree/html5.vim'
  " Bundle 'mattn/emmet-vim'
    " autocmd FileType html,css,scss,sass,stylus imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
  Bundle 'Raimondi/delimitMate'
  Bundle 'tomtom/tcomment_vim'
  "
" # Snipmate
  Bundle 'MarcWeber/vim-addon-mw-utils'
  Bundle 'tomtom/tlib_vim'
  Bundle 'garbas/vim-snipmate'
  Bundle 'shuvalov-anton/vim-snippets'

" # Linting
  Bundle 'scrooloose/syntastic'
    let g:syntastic_javascript_checkers = ['eslint']

" # Syntax support
  " Bundle 'fatih/vim-go'
  " Bundle 'kchmck/vim-coffee-script'
  Bundle 'groenewege/vim-less'
  Bundle 'digitaltoad/vim-jade'
  Bundle 'othree/javascript-libraries-syntax.vim'
    let g:used_javascript_libs = 'underscore,backbone,react,flux'
  Bundle 'pangloss/vim-javascript'
  " Bundle 'mgechev/vim-jsx'
  " Bundle 'tpope/vim-haml'
  Bundle 'plasticboy/vim-markdown'
    let g:vim_markdown_folding_disabled=1
  " Bundle 'slim-template/vim-slim.git'
  Bundle 'vim-scripts/liquid.vim'
  Bundle 'mustache/vim-mustache-handlebars'
  Bundle 'wavded/vim-stylus'
  Bundle 'gorodinskiy/vim-coloresque'
  au BufRead *.mustache set filetype=mustache " fix missed setf for mustache
  au BufRead *.json set filetype=json " fix missed setf for json
  au BufRead,BufNewFile *.es6 set filetype=javascript
  " # Integrations
  " Bundle 'vim-scripts/TaskList.vim'
  " Bundle 'junegunn/vim-github-dashboard'
  " Bundle 'heavenshell/vim-jsdoc'
    " let g:jsdoc_default_mapping=0

  syntax enable
  filetype plugin indent on
