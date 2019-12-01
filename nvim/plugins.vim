let dotfiles=$DOTFILES

if !filereadable('~/.config/nvim/plug.vim')
  silent !curl --insecure -fLo ~/.config/nvim/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

so ~/.config/nvim/plug.vim

call plug#begin('~/.vim/plugged')

  Plug 'HerringtonDarkholme/yats.vim' " Yet Another TS Syntax Plugin
  Plug 'Shougo/deoplete.nvim' " Dark powered asynchronous completion framework for neovim/Vim8
    let g:deoplete#enable_at_startup = 1
  Plug 'Shougo/denite.nvim' " Dark powered asynchronous unite all interfaces for Neovim/Vim8
    exec "so" dotfiles . '/nvim/plugin-settings/denite.vim'
  Plug 'ctrlpvim/ctrlp.vim'
    exec "so" dotfiles . '/nvim/plugin-settings/ctrlp.vim'
  Plug 'raghur/fruzzy', {'do': { -> fruzzy#install()}} " Freaky fast fuzzy Denite/CtrlP matcher for vim/neovim
    exec "so" dotfiles . '/nvim/plugin-settings/fruzzy.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
    exec "so" dotfiles . '/nvim/plugin-settings/nerttree.vim'
  Plug 'junegunn/goyo.vim'
    autocmd! User GoyoEnter set number
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
    set completeopt-=preview
  Plug 'airblade/vim-gitgutter'
  Plug 'tveskag/nvim-blame-line'
  Plug 'rhysd/git-messenger.vim'
  Plug 'mtyn/polar'
  Plug 'arcticicestudio/nord-vim'
  Plug 'ryanoasis/vim-devicons'
    exec "so" dotfiles . '/nvim/plugin-settings/devicons.vim'
  Plug 'chrisbra/Colorizer'
  Plug 'vim-airline/vim-airline'
    exec "so" dotfiles . '/nvim/plugin-settings/airline.vim'
  Plug 'tomtom/tcomment_vim'
  Plug 'editorconfig/editorconfig-vim'
    let g:EditorConfig_exclude_patterns = ['fugitive://.\*']
  Plug 'tyru/open-browser.vim'
  Plug 'pocari/vim-denite-kind-open-browser'
  Plug 'pocari/vim-denite-gists'
  Plug 'rstacruz/vim-hyperstyle'
  Plug 'chemzqm/denite-git'
  Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
    exec "so" dotfiles . '/nvim/plugin-settings/nvim-typescript.vim'
    autocmd BufWrite *.ts,*.tsx TSGetDiagnostics
  Plug 'mhinz/vim-startify'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'janko/vim-test'
    exec "so" dotfiles . '/nvim/plugin-settings/vim-test.vim'
  Plug 'dense-analysis/ale'
    exec "so" dotfiles . '/nvim/plugin-settings/ale.vim'
  Plug 'csscomb/vim-csscomb', {'do': 'npm install -g csscomb'}
  Plug 'drzel/vim-line-no-indicator'

  Plug '~/.dotfiles/nvim/local-plugins/vim-trash-polka'

call plug#end()
