filetype off

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
set clipboard=unnamedplus   " use os x/linux clipboard
set backspace=2             " use c-w and c+u
set showcmd                 " Display incomplete commands.
:au InsertEnter * set cul   " Show cursor line in insert mode
:au InsertLeave * set nocul " Hide cursor line in insert mode
set scrolloff=8             " Start scrolling when we're 8 lines away from margins
set mouse=a
set expandtab
set autoindent
set smartindent
set smarttab
set tabstop=2
set shiftwidth=2
set clipboard=unnamedplus

set cursorline
highlight CursorLineNR ctermbg=Blue ctermfg=None
" Change Color when entering Insert Mode
autocmd InsertEnter * highlight  CursorLine ctermbg=Red ctermfg=white
" Revert Color to default when leaving Insert Mode
autocmd InsertLeave * highlight  CursorLine ctermbg=Blue ctermfg=None
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
  au InsertLeave * setlocal cursorline
augroup END


" # Ident
set list              " show invisibles
set lcs=tab:▸\ ,eol:· " Use the same symbols as TextMate for tabstops and EOLs



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

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif



fun! <sid>striptrailingwhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

" automatically clean trailing whitespaces on save
autocmd bufwritepre *.* :call <sid>striptrailingwhitespaces()

" Encoding
set encoding=utf-8 nobomb
set fileencoding=utf-8 " Use UTF-8 without BOM




set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" LSP
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
Plugin 'ryanolsonx/vim-lsp-javascript'

" UI
Plugin 'scrooloose/nerdtree'
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  let NERDTreeHighlightCursorline=0
  silent! map <F4> :NERDTreeFind<CR>
  let g:NERDTreeMapActivateNode="<F4>"
  let g:NERDTreeMapPreview="<F3>"
  map <C-n> :NERDTreeToggle<CR>
  map <C-m> :NERDTreeFind<CR>

Plugin 'airblade/vim-gitgutter'
Plugin 'zivyangll/git-blame.vim'
  map <C-b> :call gitblame#echo()<CR>
Plugin 'rhysd/git-messenger.vim'
  map <C-m> :GitMessenger<CR>
Plugin 'mileszs/ack.vim'
Plugin 'chrisbra/Colorizer'

Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
  set laststatus=2                                  " vim-airline doesn't appear until I create a new split
  let g:airline_theme='lucius'                      " Colorscheme for airline
  let g:airline_left_sep = ''                       " Set custom left separator
  let g:airline_right_sep = ''                      " Set custom right separator
  let g:airline#extensions#tabline#enabled = 1      " Enable airline for tab-bar
  let g:airline#extensions#tabline#show_buffers = 0 " Don't display buffers in tab-bar with single tab
  let g:airline#extensions#tabline#fnamemod = ':t'  " Display only filename in tab
  let g:airline_section_y = ''                      " Don't display encoding
Plugin 'tomtom/tcomment_vim'
" # Linting
Plugin 'editorconfig/editorconfig-vim'
Plugin 'scrooloose/syntastic'
  let g:syntastic_javascript_checkers = ['eslint']
Plugin 'yardnsm/vim-import-cost', { 'do': 'npm install' }
  augroup import_cost_auto_run
    autocmd!
    autocmd InsertLeave *.js,*.jsx,*.ts,*.tsx ImportCost
    autocmd BufEnter *.js,*.jsx,*.ts,*.tsx ImportCost
    autocmd CursorHold *.js,*.jsx,*.ts,*.tsx ImportCost
  augroup END
Plugin 'ruanyl/vim-gh-line'
Plugin 'ap/vim-css-color'
Plugin 'mxw/vim-jsx'


call vundle#end()            " required
filetype plugin indent on    " required
