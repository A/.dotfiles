" Behavior
  set nocompatible
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
  " 'quote' a word
  nnoremap qw :silent! normal mpea'<Esc>bi'<Esc>`pl
  " double "quote" a word
  nnoremap qd :silent! normal mpea"<Esc>bi"<Esc>`pl
  " remove quotes from a word
  nnoremap wq :silent! normal mpeld bhd `ph<CR>
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
"  set paste                       " fix stupid ident error

" Invisibles
  set list                        " show invisibles
  set listchars=tab:▸\ ,eol:¬     " Use the same symbols as TextMate for tabstops and EOLs

" Bundle
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

" Timing
  Bundle 'wakatime/vim-wakatime'

" Extend vim
  Bundle 'gmarik/vundle'
  Bundle 'altercation/vim-colors-solarized'
    set background=light
    colorscheme solarized
  Bundle 'scrooloose/nerdtree'
    map <C-n> :NERDTreeToggle<CR>
    let NERDTreeHighlightCursorline=0
  Bundle 'kien/ctrlp.vim'
  Bundle 'mileszs/ack.vim'
  Bundle 'tpope/vim-fugitive'
  Bundle 'bling/vim-airline'
    set laststatus=2               " vim-airline doesn't appear until I create a new split
    let g:airline_theme='lucius'   " Colorscheme for airline
    let g:airline_left_sep = '▶'   " Set custom left separator
    let g:airline_right_sep = '◀'  " Set custom right separator
    let g:airline#extensions#tabline#enabled = 1 " Enable airline for tab-bar
    let g:airline#extensions#tabline#show_buffers = 0 " Don't display buffers in tab-bar with single tab
    let g:airline#extensions#tabline#fnamemod = ':t' " Display only filename in tab
    let g:airline_section_y = '' " Don't display encoding

" Autocomplite
  Bundle 'ervandew/supertab'
  Bundle 'mattn/emmet-vim'
  autocmd FileType stylus imap <tab> <plug>(emmet-expand-abbr)
  autocmd FileType sass imap <tab> <plug>(emmet-expand-abbr)
  autocmd FileType scss imap <tab> <plug>(emmet-expand-abbr)
  autocmd FileType css imap <tab> <plug>(emmet-expand-abbr)
  " Bundle 'Raimondi/delimitMate'
  Bundle 'tomtom/tcomment_vim'
  "
" Snipmate
  Bundle 'MarcWeber/vim-addon-mw-utils'
  Bundle 'tomtom/tlib_vim'
  Bundle 'garbas/vim-snipmate'
  Bundle 'honza/vim-snippets'

" Linting
  Bundle 'scrooloose/syntastic'
    let g:syntastic_javascript_checkers = ['jshint']

" Syntax support
  Bundle 'kchmck/vim-coffee-script'
  Bundle 'digitaltoad/vim-jade'
  Bundle 'tpope/vim-haml'
  Bundle 'plasticboy/vim-markdown'
    let g:vim_markdown_folding_disabled=1
  Bundle 'slim-template/vim-slim.git'
  Bundle 'vim-scripts/liquid.vim'
  Bundle 'wavded/vim-stylus'
  Bundle 'gorodinskiy/vim-coloresque'

   syntax enable
   filetype plugin indent on     " required!
