if !filereadable('~/.config/nvim/plug.vim')
  silent !curl --insecure -fLo ~/.config/nvim/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

so ~/.config/nvim/plug.vim

call plug#begin('~/.vim/plugged')


Plug 'HerringtonDarkholme/yats.vim' " Yet Another TS Syntax Plugin
Plug 'Shougo/deoplete.nvim' " Dark powered asynchronous completion framework for neovim/Vim8
Plug 'Shougo/denite.nvim' " Dark powered asynchronous unite all interfaces for Neovim/Vim8
  let g:deoplete#enable_at_startup = 1
  autocmd FileType denite call s:denite_my_settings()
  function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
    \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
    \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> f
    \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
    \ denite#do_map('toggle_select').'j'
  endfunction

  autocmd FileType denite-filter call s:denite_filter_my_settings()
  function! s:denite_filter_my_settings() abort
    imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
  endfunction
Plug 'ctrlpvim/ctrlp.vim'
  let g:ctrlp_root_markers = ['package.json', '.gitignore']
  let g:ctrlp_user_command = 'find %s -type f | grep -v -e "node_modules" -e "public" -e ".jest" -e ".git" -e "coverage"'
Plug 'raghur/fruzzy', {'do': { -> fruzzy#install()}} " Freaky fast fuzzy Denite/CtrlP matcher for vim/neovim
  let g:fruzzy#usenative = 1
  " call denite#custom#source('_', 'matchers', ['matcher/fruzzy'])
  let g:ctrlp_match_func = {'match': 'fruzzy#ctrlp#matcher'}
  let g:ctrlp_match_current_file = 1
Plug 'scrooloose/nerdtree'
  " " Close tab if only nerdtree left
  autocmd VimEnter *
    \   if !argc()
    \ |   Startify
    \ |   NERDTree
    \ |   wincmd w
    \ | endif
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
  let NERDTreeShowBookmarks=1
  let g:NERDTreeMapOpenSplit="h"
  let g:NERDTreeMapOpenVSplit="v"
  let g:NERDTreeMapOpenInTab="t"
  let NERDTreeHighlightCursorline=0
  let g:NERDTreeMapActivateNode="<F4>"
  let g:NERDTreeMapPreview="<F3>"
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/goyo.vim'
  autocmd! User GoyoEnter set number
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
  set completeopt-=preview
Plug 'airblade/vim-gitgutter'
Plug 'tveskag/nvim-blame-line'
  " autocmd InsertEnter * DisableBlameLine
Plug 'rhysd/git-messenger.vim'
" Plug 'flazz/vim-colorschemes'
Plug '~/.dotfiles/nvim/my-colors'

Plug 'mtyn/polar'
Plug 'arcticicestudio/nord-vim'


Plug 'ryanoasis/vim-devicons'
  let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''
  let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
  let g:NERDTreeDirArrowExpandable = "\u00a0"
  let g:NERDTreeDirArrowCollapsible = "\u00a0"
Plug 'chrisbra/Colorizer'
Plug 'bling/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
  set laststatus=2
  let g:airline_left_sep = ''
  let g:airline_right_sep = ''
  let g:airline#extensions#tabline#enabled = 0
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline_section_y = ''
Plug 'tomtom/tcomment_vim'
Plug 'editorconfig/editorconfig-vim'
  let g:EditorConfig_exclude_patterns = ['fugitive://.\*']
" Plug 'scrooloose/syntastic'
"   let g:syntastic_javascript_checkers = ['eslint']
"   let g:syntastic_typescript_checkers = ['tslint', 'tsc']
"   set statusline+=%#warningmsg#
"   set statusline+=%{SyntasticStatuslineFlag()}
"   set statusline+=%*
"   let g:syntastic_always_populate_loc_list = 1
"   let g:syntastic_auto_loc_list = 1
"   let g:syntastic_check_on_open = 1
"   let g:syntastic_check_on_wq = 0
" Plug 'A/vim-import-cost', { 'do': 'npm install' }
"   augroup import_cost_auto_run
"     autocmd!
"     autocmd InsertLeave *.js,*.jsx,*.ts,*.tsx ImportCost
"     autocmd BufEnter *.js,*.jsx,*.ts,*.tsx ImportCost
"     autocmd CursorHold *.js,*.jsx,*.ts,*.tsx ImportCost
"   augroup END
Plug 'tyru/open-browser.vim'
Plug 'pocari/vim-denite-kind-open-browser'
Plug 'pocari/vim-denite-gists'
Plug 'rstacruz/vim-hyperstyle'
Plug 'chemzqm/denite-git'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
  let g:nvim_typescript#javascript_support=1
  let g:nvim_typescript#diagnostics_enable = 0
  autocmd BufWrite *.ts,*.tsx TSGetDiagnostics
Plug 'mhinz/vim-startify'
Plug 'christoomey/vim-tmux-navigator'
Plug 'janko/vim-test'
  let test#strategy = "neovim"
  let g:test#javascript#mocha#file_pattern = '\v.*\.spec\.(ts|tsx)$'
  let g:test#runner_commands = ["jest", "reactscripts"]
Plug 'alvan/vim-closetag'
  let g:closetag_filenames = '*.html,*.jsx,*.tsx'
  let g:closetag_regions =  {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }
Plug 'dense-analysis/ale'
  let g:ale_sign_error = ' '
  let g:ale_sign_warning = ' '
  let g:airline#extensions#ale#enabled = 1
  let g:ale_open_list = 0
  let g:ale_list_window_size = 5
  let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'javascript': ['eslint'],
    \ 'typescript': ['eslint'],
  \}
Plug 'csscomb/vim-csscomb', {'do': 'npm install -g csscomb'}

call plug#end()
