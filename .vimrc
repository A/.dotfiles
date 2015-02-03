" Just search by `/# ` to navigate between parts of the file
" # Behavior
  set nocompatible
  set nobackup
  set noswapfile
  set history=1000                                          " remember more commands and search history
  set undolevels=1000                                       " use many muchos levels of undo
  set noeb vb t_vb=                                         " disable error beeping
  set tildeop                                               " use ~ as operator for text objects like `~iw`
  set nowrap                                                " hate wrapping for tiny windows. It makes code absolute unreadable

" # UX
  set title                                                 " Show the (partial) command as it’s being typed
  set number                                                " Show line numbers
  set nostartofline                                         " Don’t reset cursor to start of line when moving around.
  set ruler                                                 " Show the cursor position
  set colorcolumn=80,120
  set showmode                                              " Show the current mode
  set clipboard=unnamed
  set backspace=indent,eol,start
  set noeol                                                 " Don’t add empty newlines at the end of files
  set showcmd                                               " Display incomplete commands.
  :au InsertEnter * set cul                            " Show cursor line in insert mode
  :au InsertLeave * set nocul                          " Hide cursor line in insert mode
  set scrolloff=8                                           " Start scrolling when we're 8 lines away from margins
  set sidescrolloff=15
  set sidescroll=1
  " Shortcuts for moving between tabs.
  " C-Left to move to the tab to the left
  noremap <f3> gT
  " C-Right to move to the tab to the right
  noremap <f4> gt
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
  noremap <C-j> <C-W>j
  noremap <C-k> <C-W>k
  noremap <C-h> <C-W>h
  noremap <C-l> <C-W>l

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
  set fileencoding=utf-8                                    " Use UTF-8 without BOM
  set encoding=utf-8 nobomb

" # Search
  set ignorecase                                            " Ignore case of searches
  set incsearch
  set hlsearch                                              " Highlight searches

" # Ident
  set tabstop=2
  set shiftwidth=2
  set smarttab
  set expandtab
  set autoindent
  set smartindent
  set pastetoggle=<F2>


" # Invisibles
  " set list                                                  " show invisibles
  " set lcs=tab:▸\ ,eol:¬                                     " Use the same symbols as TextMate for tabstops and EOLs

" # Bundle
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

" # Timing
  Bundle 'wakatime/vim-wakatime'

" # Extend vim
  " use russian layout the only in the insert mode
  Bundle 'porqz/KeyboardLayoutSwitcher'
  " Bundle 'mattesgroeger/vim-bookmarks'
  Bundle 'tpope/vim-surround'
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
    colorscheme seoul256
  " Bundle 'altercation/vim-colors-solarized'
  "   set background=dark
  "   colorscheme solarized
  Bundle 'scrooloose/nerdtree'
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    map <C-n> :NERDTreeToggle<CR>
  " Bundle 'jistr/vim-nerdtree-tabs'
    let NERDTreeHighlightCursorline=0
  Bundle 'kien/ctrlp.vim'
  Bundle 'mileszs/ack.vim'
  " Git goodies
  Bundle 'tpope/vim-fugitive'
  Bundle 'bling/vim-airline'
    set laststatus=2                                        " vim-airline doesn't appear until I create a new split
    let g:airline_theme='lucius'                            " Colorscheme for airline
    let g:airline_left_sep = ''                             " Set custom left separator
    let g:airline_right_sep = ''                            " Set custom right separator
    let g:airline#extensions#tabline#enabled = 1            " Enable airline for tab-bar
    let g:airline#extensions#tabline#show_buffers = 0       " Don't display buffers in tab-bar with single tab
    let g:airline#extensions#tabline#fnamemod = ':t'        " Display only filename in tab
    let g:airline_section_y = ''                            " Don't display encoding
  Bundle 'Shougo/unite.vim'

" # Autocomplite
  Bundle 'ervandew/supertab'
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
    let g:syntastic_javascript_checkers = ['jshint']

" # Syntax support
  " Bundle 'fatih/vim-go'
  " Bundle 'kchmck/vim-coffee-script'
  Bundle 'digitaltoad/vim-jade'
  " Bundle 'tpope/vim-haml'
  Bundle 'plasticboy/vim-markdown'
    let g:vim_markdown_folding_disabled=1
  " Bundle 'slim-template/vim-slim.git'
  Bundle 'vim-scripts/liquid.vim'
  Bundle 'wavded/vim-stylus'
  Bundle 'gorodinskiy/vim-coloresque'
  au BufRead *.json set filetype=json " fix json mistype
  " # Integrations
  " Bundle 'vim-scripts/TaskList.vim'
  " Bundle 'junegunn/vim-github-dashboard'
  " Bundle 'heavenshell/vim-jsdoc'
    " let g:jsdoc_default_mapping=0

  syntax enable
  filetype plugin indent on
