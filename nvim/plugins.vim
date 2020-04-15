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
  Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}

  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
    so $DOTFILES/nvim/plugin-settings/nvim-typescript.vim
    autocmd BufWrite *.ts,*.tsx TSGetDiagnostics


  " Core
  Plug 'Shougo/denite.nvim'
  Plug 'dense-analysis/ale'
    so $DOTFILES/nvim/plugin-settings/ale.vim
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'scrooloose/nerdtree'
    so $DOTFILES/nvim/plugin-settings/nerttree.vim
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'ryanoasis/vim-devicons'
    so $DOTFILES/nvim/plugin-settings/devicons.vim
  Plug 'vim-airline/vim-airline'
    so $DOTFILES/nvim/plugin-settings/airline.vim
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'drzel/vim-line-no-indicator'
  " Plug 'mhinz/vim-startify'

  " Codding
  Plug 'editorconfig/editorconfig-vim'
    let g:EditorConfig_exclude_patterns = ['fugitive://.\*']
  Plug 'chrisbra/Colorizer'
  Plug 'tomtom/tcomment_vim'
  Plug 'rstacruz/vim-closer'
  Plug 'rstacruz/vim-hyperstyle'

  " Git
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
    set completeopt-=preview
  Plug 'airblade/vim-gitgutter'
  Plug 'rhysd/git-messenger.vim'
  Plug 'chemzqm/denite-git'

  " Markdown
  Plug 'gabrielelana/vim-markdown'
  Plug 'rhysd/vim-gfm-syntax'
    let g:markdown_enable_mappings = 0
  Plug 'ferrine/md-img-paste.vim'

  " Plug 'a/vim-trash-polka'
  Plug '~/.dotfiles/nvim/local-plugins/vim-trash-polka'

call plug#end()

so $DOTFILES/nvim/plugin-settings/denite.vim
