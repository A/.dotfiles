let dotfiles=$DOTFILES

if !filereadable('~/.config./plug.vim')
  silent !curl --insecure -fLo ~/.config./plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

so ~/.config/nvim/plug.vim

call plug#begin('~/.vim/plugged')

  Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
  Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
  " Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
  " Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile'} " mru and stuff
  Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'} " color highlighting

  Plug 'HerringtonDarkholme/yats.vim' " Yet Another TS Syntax Plugin
  Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
    so plugin-settings/nvim-typescript.vim
    autocmd BufWrite *.ts,*.tsx TSGetDiagnostics


  " Core
  " Plug 'Shougo/deoplete.nvim' " Dark powered asynchronous completion framework for neovim/Vim8
  "   let g:deoplete#enable_at_startup = 1
  Plug 'Shougo/denite.nvim' " Dark powered asynchronous unite all interfaces for Neovim/Vim8

  " Syntax
  Plug 'tpope/vim-markdown'
    let g:markdown_fenced_languages = ['css', 'javascript', 'js=javascript', 'json=javascript', 'typescript', 'tsx=typescriptreact', 'xml']


  " Plug 'ctrlpvim/ctrlp.vim'
  "   so ./plugin-settings/ctrlp.vim
  Plug 'raghur/fruzzy', {'do': { -> fruzzy#install()}} " Freaky fast fuzzy Denite/CtrlP matcher for vim/neovim
    so ./plugin-settings/fruzzy.vim
  " Plug 'cocopon/vaffle.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
    so ./plugin-settings/nerttree.vim
  Plug 'junegunn/goyo.vim'
    autocmd! User GoyoEnter set number
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
    set completeopt-=preview
  Plug 'airblade/vim-gitgutter'
  Plug 'rhysd/git-messenger.vim'
  Plug 'mtyn/polar'
  Plug 'arcticicestudio/nord-vim'
  Plug 'ryanoasis/vim-devicons'
    so ./plugin-settings/devicons.vim
  Plug 'chrisbra/Colorizer'
  Plug 'vim-airline/vim-airline'
    so ./plugin-settings/airline.vim
  Plug 'tomtom/tcomment_vim'
  Plug 'editorconfig/editorconfig-vim'
    let g:EditorConfig_exclude_patterns = ['fugitive://.\*']
  Plug 'tyru/open-browser.vim'
  Plug 'pocari/vim-denite-kind-open-browser'
  Plug 'pocari/vim-denite-gists'
  Plug 'rstacruz/vim-hyperstyle'
  Plug 'chemzqm/denite-git'
  Plug 'mhinz/vim-startify'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'janko/vim-test'
    so ./plugin-settings/vim-test.vim
  Plug 'dense-analysis/ale'
    so ./plugin-settings/ale.vim
  Plug 'drzel/vim-line-no-indicator'
  Plug 'dominikduda/vim_es7_javascript_react_snippets'
  Plug 'rstacruz/vim-closer'

  " Plug 'a/vim-trash-polka'
  Plug '~/.dotfiles/nvim/local-plugins/vim-trash-polka'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
call plug#end()

so ./plugin-settings/denite.vim
