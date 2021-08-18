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

" Remember folding through sessions
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview
au InsertEnter * set nocursorline
au InsertLeave * set cursorline

" Bindings
let mapleader = " "

" Coc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gE :CocCommand eslint.executeAutofix<CR>
nnoremap <silent> K :call ShowDocumentation()<CR>

nmap <leader>rr <Plug>(coc-rename)
nmap <leader>rl <Plug>(coc-codeaction)

" fzf
noremap <leader>fp :Buffers<CR>
noremap <leader>fp :Files<CR>
noremap <leader>fg :RG<Cr>

" NERDTree
noremap <leader>ft :NERDTreeToggle<CR>
noremap <leader>ff :NERDTreeFind<CR>

" tcomment
noremap <leader>cc :TComment<CR>

" vim-fugitive
noremap <leader>gb :GBlame<CR>
noremap <leader>gh :GBrowse<CR>

" git-messenger
noremap <leader>gm :GitMessenger<CR>

" zen-mode
noremap <leader>vm :TZMinimalist<CR>
noremap <leader>vf :TZFocus<CR>

" refactoring


" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" ripgrep
if executable('rg')
  set grepprg=rg\ --color=never\ --vimgrep
endif

" coc hover
function! ShowDocumentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


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

" Plug 'a/vim-trash-polka'
" Plug 'jeffkreeftmeijer/vim-dim'
Plug 'arcticicestudio/nord-vim'
Plug 'A/vim-trash-polka'

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-eslint', { 'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-prettier', { 'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-yaml', { 'do': 'yarn install --frozen-lockfile' }

  autocmd FileType scss setl iskeyword+=@-@

Plug 'pechorin/any-jump.vim'

Plug 'sheerun/vim-polyglot'

Plug 'junegunn/fzf', {'do': '{ -> fzf#install() } }' }
Plug 'junegunn/fzf.vim'
  function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': [
      \ '--preview-window=right',
      \ '--phony',
      \ '--query',
      \ a:query,
      \ '--bind',
      \ 'change:reload:'.reload_command
      \]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction
  command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
  " airline settings
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

Plug 'drzel/vim-line-no-indicator'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
  let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''
  let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
  let g:NERDTreeDirArrowExpandable = "\u00a0"
  let g:NERDTreeDirArrowCollapsible = "\u00a0"

  let NERDTreeMinimalUI=1
  let g:NERDTreeMapOpenSplit="h"
  let g:NERDTreeMapOpenVSplit="v"
  let g:NERDTreeMapOpenInTab="t"
  let NERDTreeHighlightCursorline=0
  let g:NERDTreeMapActivateNode="<F4>"
  let g:NERDTreeMapPreview="<F3>"
  let g:NERDTreeIgnore = ['^node_modules$']
  let g:NERDTreeWinPos = "left"

  autocmd VimEnter *
    \   if !argc()
    \ |   NERDTree
    \ |   wincmd w
    \ | endif
  autocmd bufenter *
    \ if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

Plug 'editorconfig/editorconfig-vim'
  let g:EditorConfig_exclude_patterns = ['fugitive://.\*']

Plug 'chrisbra/Colorizer'
  au BufRead,BufNewFile *.css,*.scss,*.less,*.js,*.coffee,*.ts,*.tsx ColorHighlight

Plug 'tomtom/tcomment_vim'
Plug 'rstacruz/vim-closer'
Plug 'rstacruz/vim-hyperstyle'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'

Plug 'kdav5758/TrueZen.nvim'

call plug#end()

if plug_install
  PlugInstall --sync
endif
unlet plug_install

au BufRead,BufNewFile *.md setlocal textwidth=80
function SetMarkdownOption()
  setlocal wrap
  setlocal linebreak
  setlocal nolist
  setlocal ts=120
endfunction

colorscheme trash-polka
let g:airline_theme='trashpolka'
