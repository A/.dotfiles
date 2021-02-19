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

" Remember folding through sessions
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview
au InsertEnter * set nocursorline
au InsertLeave * set cursorline

set updatetime=750

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

nmap <silent> gF :vsp<CR>gf

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
Plug 'a/vim-trash-polka'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', {'do': '{ -> fzf#install() } }' }
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'drzel/vim-line-no-indicator'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'editorconfig/editorconfig-vim'
Plug 'chrisbra/Colorizer'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
" END ANSIBLE MANAGED BLOCK nvim-plugins

call plug#end()

if plug_install
  PlugInstall --sync
endif
unlet plug_install

" BEGIN ANSIBLE MANAGED BLOCK junegunn/fzf
noremap <leader>fp :FZF<CR>
" END ANSIBLE MANAGED BLOCK junegunn/fzf
" BEGIN ANSIBLE MANAGED BLOCK ryanoasis/vim-devicons
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
let g:NERDTreeDirArrowExpandable = "\u00a0"
let g:NERDTreeDirArrowCollapsible = "\u00a0"
" END ANSIBLE MANAGED BLOCK ryanoasis/vim-devicons
" BEGIN ANSIBLE MANAGED BLOCK vim-airline/vim-airline
set laststatus=2
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#nerdtree_status = 0
let g:airline#extensions#tabline#fnamemod = ':t'
"" let g:airline_section_b = g:airline#section#create(['hunks'])
let g:airline_section_x = ''
let g:airline_section_y = '%{LineNoIndicator()}'
let g:airline_section_z = '%2c'
" END ANSIBLE MANAGED BLOCK vim-airline/vim-airline
" BEGIN ANSIBLE MANAGED BLOCK scrooloose/nerdtree
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
let NERDTreeHighlightCursorline=0
let g:NERDTreeIgnore = ['^node_modules$']
let g:NERDTreeWinPos = "left"
" END ANSIBLE MANAGED BLOCK scrooloose/nerdtree
" BEGIN ANSIBLE MANAGED BLOCK editorconfig/editorconfig-vim
let g:EditorConfig_exclude_patterns = ['fugitive://.\*']
" END ANSIBLE MANAGED BLOCK editorconfig/editorconfig-vim
" BEGIN ANSIBLE MANAGED BLOCK tomtom/tcomment_vim
noremap <leader>cc :TComment<CR>
noremap <leader>cC :TCommentInline<CR>
" END ANSIBLE MANAGED BLOCK tomtom/tcomment_vim
" BEGIN ANSIBLE MANAGED BLOCK tpope/vim-fugitive
noremap <leader>ga :GBlame<CR>
noremap <leader>gh :GBrowse<CR>
" END ANSIBLE MANAGED BLOCK tpope/vim-fugitive
" BEGIN ANSIBLE MANAGED BLOCK tpope/vim-rhubarb
set completeopt-=preview
" END ANSIBLE MANAGED BLOCK tpope/vim-rhubarb
" BEGIN ANSIBLE MANAGED BLOCK rhysd/git-messenger.vim
noremap <leader>gm :GitMessenger<CR>
" END ANSIBLE MANAGED BLOCK rhysd/git-messenger.vim
" BEGIN ANSIBLE MANAGED BLOCK ripgrep
if executable('rg')
  set grepprg=rg\ --color=never\ --vimgrep
endif
" END ANSIBLE MANAGED BLOCK ripgrep
" BEGIN ANSIBLE MANAGED BLOCK a/vim-trash-polka
colorscheme trash-polka
let g:airline_theme='trashpolka'
" END ANSIBLE MANAGED BLOCK a/vim-trash-polka
" BEGIN ANSIBLE MANAGED BLOCK neovim/nvim-lspconfig
lua << EOF
  require'lspconfig'.tsserver.setup{on_attach=require'completion'.on_attach}
  require'lspconfig'.vimls.setup{on_attach=require'completion'.on_attach}
  require'lspconfig'.yamlls.setup{on_attach=require'completion'.on_attach}
  require'lspconfig'.rls.setup{on_attach=require'completion'.on_attach}
  require'lspconfig'.bashls.setup{on_attach=require'completion'.on_attach}

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
          underline = true,
          virtual_text = false
      }
  )
EOF

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gt   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gF    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> ge    <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

set completeopt=menuone,noinsert,noselect
set shortmess+=c
" END ANSIBLE MANAGED BLOCK neovim/nvim-lspconfig
