filetype off

set nocompatible
set nobackup
set noswapfile
set noeb vb t_vb=           " disable error beeping
set tildeop                 " use ~ as operator for text objects like `~iw`
set nowrap                  " hate wrapping for tiny windows. It makes code absolute unreadable
set number                  " Show line numbers
highlight LineNr ctermfg=grey
set nostartofline           " Don’t reset cursor to start of line when moving around.
set colorcolumn=120          " bad and extrabad line sizes
set showmode                " Show the current mode
set clipboard=unnamed       " use os x/linux clipboard
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
au InsertEnter * set nocursorline
au InsertLeave * set cursorline
highlight CursorLineNR ctermbg=DarkGray ctermfg=None
" " Change Color when entering Insert Mode
" autocmd InsertEnter * highlight  CursorLine ctermbg=Red ctermfg=white
" " Revert Color to default when leaving Insert Mode
" autocmd InsertLeave * highlight  CursorLine ctermbg=DarkGray ctermfg=None
" augroup CursorLine
"   au!
"   au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
"   au WinLeave * setlocal nocursorline
"   au InsertLeave * setlocal cursorline
" augroup END
"

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

" TS
map <C-t> :TSType<CR>
map <C-h> :TSGetDiagnostics<CR>

" NERDTree
silent! map <F4> :NERDTreeFind<CR>
map <C-n> :NERDTreeToggle<CR>


map <C-f> :Goyo<CR>
map <C-b> :ToggleBlameLine<CR>
map <C-m> :GitMessenger<CR>

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

let g:python_host_prog = '/usr/local/bin/python2.7'
let g:python2_host_prog = '/usr/local/bin/python2.7'
let g:python3_host_prog = '/usr/local/bin/python3.7'


if !filereadable('~/.config/nvim/plug.vim')
  silent !curl --insecure -fLo ~/.config/nvim/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

so ~/.config/nvim/plug.vim

call plug#begin('~/.vim/plugged')

Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
  g:nvim_typescript#diagnostics_enable=0
  autocmd BufWrite *.ts,*.tsx TSGetDiagnostics
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/denite.nvim'
  let g:deoplete#enable_at_startup = 1

"" NERD TREE
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdtree'
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  " Close tab if only nerdtree left
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
  let NERDTreeShowBookmarks=1
  let g:NERDTreeMapOpenSplit="h"
  let g:NERDTreeMapOpenVSplit="v"
  let g:NERDTreeMapOpenInTab="t"
  let NERDTreeHighlightCursorline=0
  let g:NERDTreeMapActivateNode="<F4>"
  let g:NERDTreeMapPreview="<F3>"

Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-surround'
Plug 'junegunn/limelight.vim'
  let g:limelight_conceal_ctermfg = 'gray'
  autocmd! User GoyoEnter Limelight
  autocmd! User GoyoLeave Limelight!
  autocmd! User GoyoEnter set number
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tveskag/nvim-blame-line'
  " autocmd InsertEnter * DisableBlameLine
  " autocmd InsertLeave * EnableBlameLine
" Plug 'zivyangll/git-blame.vim'
Plug 'rhysd/git-messenger.vim'
Plug 'mileszs/ack.vim'
Plug 'chrisbra/Colorizer'
Plug 'ctrlpvim/ctrlp.vim'
  let g:ctrlp_root_markers = ['package.json', '.gitignore']
  let g:ctrlp_user_command = 'find %s -type f | grep -v -e "node_modules" -e "public" -e ".jest" -e ".git" -e "coverage"'

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
  set laststatus=2                                  " vim-airline doesn't appear until I create a new split
  let g:airline_theme='lucius'                      " Colorscheme for airline
  let g:airline_left_sep = ''                       " Set custom left separator
  let g:airline_right_sep = ''                      " Set custom right separator
  let g:airline#extensions#tabline#enabled = 1      " Enable airline for tab-bar
  let g:airline#extensions#tabline#show_buffers = 0 " Don't display buffers in tab-bar with single tab
  let g:airline#extensions#tabline#fnamemod = ':t'  " Display only filename in tab
  let g:airline_section_y = ''                      " Don't display encoding
Plug 'tomtom/tcomment_vim'
" # Linting
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/syntastic'
  let g:syntastic_javascript_checkers = ['eslint']
  let g:syntastic_typescript_checkers = ['tslint', 'tsc']
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
Plug 'yardnsm/vim-import-cost', { 'do': 'npm install' }
  " augroup import_cost_auto_run
  "   autocmd!
  "   autocmd InsertLeave *.js,*.jsx,*.ts,*.tsx ImportCost
  "   autocmd BufEnter *.js,*.jsx,*.ts,*.tsx ImportCost
  "   autocmd CursorHold *.js,*.jsx,*.ts,*.tsx ImportCost
  " augroup END
Plug 'ruanyl/vim-gh-line'
Plug 'ap/vim-css-color'
Plug 'mxw/vim-jsx'
Plug 'heavenshell/vim-jsdoc'

"" Gists
Plug 'Shougo/denite.nvim'
Plug 'tyru/open-browser.vim'
Plug 'pocari/vim-denite-kind-open-browser'
Plug 'pocari/vim-denite-gists'
Plug 'rstacruz/vim-hyperstyle'

call plug#end()

