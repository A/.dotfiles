" Behavior
    set nocompatible
    filetype off
    set nobackup
    set noswapfile
    set history=1000                " remember more commands and search history
    set undolevels=1000             " use many muchos levels of undo
    set noeb vb t_vb=               " disable error beeping

" UX
    set number                      " Show line numbers
    set nostartofline               " Don’t reset cursor to start of line when moving around.
    set ruler                       " Show the cursor position
    set colorcolumn=80,120
    set showmode                    " Show the current mode
    set clipboard=unnamed
    set backspace=indent,eol,start
    set noeol                       " Don’t add empty newlines at the end of files
    set showcmd                     " Display incomplete commands. 
    :autocmd InsertEnter * set cul  " Show cursor line in insert mode
    :autocmd InsertLeave * set nocul " Hide cursor line in insert mode
    " Shortcuts for moving between tabs.
    " Alt-j to move to the tab to the left
    noremap <C-j> gT
    " Alt-k to move to the tab to the right
    noremap <C-k> gt
    " Return to last edit position when opening files (You want this!)
    autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
    " Remember info about open buffers on close
    set viminfo^=%

" Status line
    set laststatus=2
    set statusline=
    set statusline+=%-3.3n\         " buffer number
    set statusline+=%f\             " filename
    set statusline+=%h%m%r%w        " file status
    set statusline+=\[%{strlen(&ft)?&ft:'none'}] " filetype
    set statusline+=%=
    set statusline+=%-14(%l,%c%V%)  " line character
    set statusline+=%<%P            " file position


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
    set paste                       " fix stupid ident error

" Invisibles
    set list                        " show invisibles 
    set listchars=tab:▸\ ,eol:¬     " Use the same symbols as TextMate for tabstops and EOLs

" Bundle
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

" Extend vim
    Bundle 'gmarik/vundle'
    Bundle 'altercation/vim-colors-solarized'
      set background=dark
      colorscheme solarized
    Bundle 'scrooloose/nerdtree'
      map <C-n> :NERDTreeToggle<CR>
      let NERDTreeHighlightCursorline=0
    Bundle 'kien/ctrlp.vim'
    Bundle 'mileszs/ack.vim'

" Autocomplite
    Bundle 'ervandew/supertab'
    " Bundle 'mattn/emmet-vim'
" Snipmate
    Bundle "MarcWeber/vim-addon-mw-utils"
    Bundle "tomtom/tlib_vim"
    Bundle "garbas/vim-snipmate"
    Bundle "honza/vim-snippets"

" Linting
    Bundle 'scrooloose/syntastic'
      filetype plugin indent on     " required!
      let g:syntastic_javascript_checkers = ['jshint']

" Syntax support
    syntax enable
    Bundle 'kchmck/vim-coffee-script'
    Bundle 'digitaltoad/vim-jade'
    Bundle 'tpope/vim-haml'
    Bundle 'plasticboy/vim-markdown'
    Bundle 'slim-template/vim-slim.git'
    Bundle 'vim-scripts/liquid.vim'
    Bundle 'wavded/vim-stylus'
