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

Plug 'neoclide/coc.nvim', {'do': '{ -> coc#util#install() }' }
Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-eslint', { 'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-prettier', { 'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/coc-yaml', { 'do': 'yarn install --frozen-lockfile' }

Plug 'pechorin/any-jump.vim'

Plug 'sheerun/vim-polyglot'

Plug 'junegunn/fzf', {'do': '{ -> fzf#install() } }' }
Plug 'junegunn/fzf.vim'

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

Plug 'kdav5758/TrueZen.nvim'

" Plug 'vimwiki/vimwiki'

call plug#end()

if plug_install
  PlugInstall --sync
endif
unlet plug_install
