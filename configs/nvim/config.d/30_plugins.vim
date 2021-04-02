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

Plug 'a/vim-trash-polka'

Plug 'neoclide/coc.nvim', {'do': '{ -> coc#util#install() }' }
Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-eslint', { 'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-prettier', { 'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-yaml', { 'do': 'yarn install --frozen-lockfile' }

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'HerringtonDarkholme/yats.vim'
Plug 'Shougo/denite.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

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

call plug#end()

if plug_install
  PlugInstall --sync
endif
unlet plug_install
