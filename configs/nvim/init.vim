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

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gt   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gF    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> ge    <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> rr    <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> rl    <cmd>lua vim.lsp.buf.code_action()<CR>

autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

set completeopt=menuone,noinsert,noselect
set shortmess+=c

nmap <silent> gE :CocCommand eslint.executeAutofix<CR>

" fzf
" noremap <leader>fp :Buffers<CR>
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
Plug 'A/vim-trash-polka'
Plug 'sheerun/vim-polyglot'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'creativenull/diagnosticls-configs-nvim'
" Plug 'nvim-lua/lsp-status.nvim'

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

lua << EOF
  local nvim_lsp = require('lspconfig')
  local dls = require('diagnosticls-configs')

  local servers = {'tsserver', 'vimls', 'yamlls'}

  local on_attach = function(_, bufnr)
    require('completion').on_attach()
  end

  dls.init({ on_attach = on_attach })
  dls.setup({
    javascript = {
      linter = require 'diagnosticls-configs.linters.eslint_d',
      formatter = require 'diagnosticls-configs.formatters.prettier',
    },
    javascriptreact = {
      linter = require 'diagnosticls-configs.linters.eslint_d',
      formatter = require 'diagnosticls-configs.formatters.prettier',
    },
    typescript = {
      linter = require 'diagnosticls-configs.linters.eslint_d',
      formatter = require 'diagnosticls-configs.formatters.prettier',
    },
    typescriptreact = {
      linter = require 'diagnosticls-configs.linters.eslint_d',
      formatter = require 'diagnosticls-configs.formatters.prettier',
    },
  })

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
          underline = true,
          virtual_text = false,
          signs = true,
      }
  )

  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end
EOF

