let plug_install = 0
let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
if !filereadable(autoload_plug_path)
    silent exe '!curl -fL --create-dirs -o ' . autoload_plug_path .
        \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    execute 'source ' . fnameescape(autoload_plug_path)
    let plug_install = 1
endif
unlet autoload_plug_path

call plug#begin(g:config_dir . 'plugins')

  Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
  Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}
  
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
    exec "so " . g:config_dir . 'plugin-settings/nvim-typescript.vim'
    autocmd BufWrite *.ts,*.tsx TSGetDiagnostics
  
 
  " Core
  Plug 'Shougo/denite.nvim'
  Plug 'dense-analysis/ale'
    exec "so " . g:config_dir . 'plugin-settings/ale.vim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'scrooloose/nerdtree'
    exec "so " . g:config_dir . 'plugin-settings/nerttree.vim'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'ryanoasis/vim-devicons'
    exec "so " . g:config_dir . 'plugin-settings/devicons.vim'
  Plug 'vim-airline/vim-airline'
    exec "so " . g:config_dir . 'plugin-settings/airline.vim'
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
  Plug 'arcticicestudio/nord-vim'
  exec "Plug " . "'" . g:config_dir . "local-plugins/vim-trash-polka'"

call plug#end()

if plug_install
    PlugInstall --sync
endif
unlet plug_install

exec "so " . g:config_dir . 'plugin-settings/denite.vim'
