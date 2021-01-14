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

" PLUGINS PLACEHOLDER
" BEGIN ANSIBLE MANAGED BLOCK nvim-plugins
Plug 'neoclide/coc.nvim', {'do': '{ -> coc#util#install() }' }
Plug 'neoclide/coc-snippets'
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-css'
Plug 'neoclide/coc-lists'
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile' }
Plug 'HerringtonDarkholme/yats.vim'
Plug 'Shougo/denite.nvim'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', {'do': '{ -> fzf#install() } }' }
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'drzel/vim-line-no-indicator'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'editorconfig/editorconfig-vim'
Plug 'chrisbra/Colorizer'
Plug 'tomtom/tcomment_vim'
Plug 'rstacruz/vim-closer'
Plug 'rstacruz/vim-hyperstyle'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'
Plug 'chemzqm/denite-git'
Plug 'gabrielelana/vim-markdown'
" END ANSIBLE MANAGED BLOCK nvim-plugins
"
call plug#end()

if plug_install
  PlugInstall --sync
endif
unlet plug_install

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif


nmap <silent> gF :vsp<CR>gf
noremap <leader>fs :Vgrep
" BEGIN ANSIBLE MANAGED BLOCK neoclide/coc.nvim-settings
nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
nmap    <leader>cr  <Plug>(coc-rename)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
imap <C-e> <Plug>(coc-snippets-expand-jump)
function! ShowDocumentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nnoremap <silent> K :call ShowDocumentation()<CR>
" END ANSIBLE MANAGED BLOCK neoclide/coc.nvim-settings
" BEGIN ANSIBLE MANAGED BLOCK mhartington/nvim-typescript-settings
let g:nvim_typescript#javascript_support=1
let g:nvim_typescript#diagnostics_enable = 0
autocmd BufWrite *.ts,*.tsx TSGetDiagnostics
" END ANSIBLE MANAGED BLOCK mhartington/nvim-typescript-settings
" BEGIN ANSIBLE MANAGED BLOCK Shougo/denite.nvim-settings
noremap <leader>fS :DeniteCursorWord grep<CR>
noremap <leader>fb :Denite buffer<CR>
noremap <leader>vc :Denite colorscheme<CR>
noremap <leader>gi :Denite gists<CR>
noremap <leader>gf :Denite gitlog<CR>
noremap <leader>gl :Denite gitlog:all<CR>
noremap <leader>gs :Denite gitstatus<CR>
noremap <leader>gb :Denite gitbranch<CR>
" END ANSIBLE MANAGED BLOCK Shougo/denite.nvim-settings
" BEGIN ANSIBLE MANAGED BLOCK dense-analysis/ale-settings
noremap <leader>cE <Plug>(ale_previous_wrap)
noremap <leader>ce <Plug>(ale_next_wrap)

let g:ale_sign_error = ' '
let g:ale_sign_warning = ' '
let g:airline#extensions#ale#enabled = 1
let g:ale_open_list = 0
let g:ale_list_window_size = 5
let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'javascriptreact': ['prettier'],
  \ 'javascript': ['prettier'],
  \ 'typescriptreact': ['prettier'],
  \ 'typescript': ['prettier'],
  \ 'css': ['prettier'],
\}
let g:ale_linters = {
\   'typescript': ['eslint', 'tsc'],
\   'typescriptreact': ['eslint', 'tsc'],
\   'javascript': ['eslint'],
\   'javascriptreact': ['eslint'],
\}
let g:ale_fix_on_save = 0
let g:ale_linters_explicit = 1
" END ANSIBLE MANAGED BLOCK dense-analysis/ale-settings
" BEGIN ANSIBLE MANAGED BLOCK junegunn/fzf-settings
noremap <leader>fp :FZF<CR>
" END ANSIBLE MANAGED BLOCK junegunn/fzf-settings
" BEGIN ANSIBLE MANAGED BLOCK ryanoasis/vim-devicons-settings
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
let g:NERDTreeDirArrowExpandable = "\u00a0"
let g:NERDTreeDirArrowCollapsible = "\u00a0"
" END ANSIBLE MANAGED BLOCK ryanoasis/vim-devicons-settings
" BEGIN ANSIBLE MANAGED BLOCK vim-airline/vim-airline-settings
set laststatus=2

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#nerdtree_status = 0
let g:airline#extensions#tabline#fnamemod = ':t'

let g:airline_symbols.branch = ''
let g:airline#extensions#branch#format = 1
"" let g:airline_section_b = g:airline#section#create(['branch', 'hunks'])
let g:airline_section_x = ''
let g:airline_section_y = '%{LineNoIndicator()}'
let g:airline_section_z = '%2c'
" END ANSIBLE MANAGED BLOCK vim-airline/vim-airline-settings
" BEGIN ANSIBLE MANAGED BLOCK scrooloose/nerdtree-settings
noremap <leader>ft :NERDTreeToggle<CR>
noremap <leader>ff :NERDTreeFind<CR>
autocmd VimEnter *
  \   if !argc()
  \ |   NERDTree
  \ |   wincmd w
  \ | endif
autocmd bufenter * 
  \ if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeMinimalUI=1
let g:NERDTreeMapOpenSplit="h"
let g:NERDTreeMapOpenVSplit="v"
let g:NERDTreeMapOpenInTab="t"
let NERDTreeHighlightCursorline=0
let g:NERDTreeMapActivateNode="<F4>"
let g:NERDTreeMapPreview="<F3>"
let g:NERDTreeIgnore = ['^node_modules$']
let g:NERDTreeWinPos = "left"
" END ANSIBLE MANAGED BLOCK scrooloose/nerdtree-settings
" BEGIN ANSIBLE MANAGED BLOCK editorconfig/editorconfig-vim-settings
let g:EditorConfig_exclude_patterns = ['fugitive://.\*']
" END ANSIBLE MANAGED BLOCK editorconfig/editorconfig-vim-settings
" BEGIN ANSIBLE MANAGED BLOCK tomtom/tcomment_vim-settings
noremap <leader>cc :TComment<CR>
noremap <leader>cC :TCommentInline<CR>
" END ANSIBLE MANAGED BLOCK tomtom/tcomment_vim-settings
" BEGIN ANSIBLE MANAGED BLOCK tpope/vim-fugitive-settings
noremap <leader>ga :GBlame<CR>
noremap <leader>gh :GBrowse<CR>
" END ANSIBLE MANAGED BLOCK tpope/vim-fugitive-settings
" BEGIN ANSIBLE MANAGED BLOCK tpope/vim-rhubarb-settings
set completeopt-=preview
" END ANSIBLE MANAGED BLOCK tpope/vim-rhubarb-settings
" BEGIN ANSIBLE MANAGED BLOCK rhysd/git-messenger.vim-settings
noremap <leader>gm :GitMessenger<CR>
" END ANSIBLE MANAGED BLOCK rhysd/git-messenger.vim-settings
" BEGIN ANSIBLE MANAGED BLOCK ripgrep
if executable('rg')
  set grepprg=rg\ --color=never\ --vimgrep
endif
" END ANSIBLE MANAGED BLOCK ripgrep

