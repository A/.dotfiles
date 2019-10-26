let dotfiles=$DOTFILES
exec "so" dotfiles . '/nvim/settings.vim'
exec "so" dotfiles . '/nvim/plugins.vim'
exec "so" dotfiles . '/nvim/utils.vim'


let mapleader = " "

" Vim
noremap <leader>vt gt
noremap <leader>vT gT
noremap <leader>vtn :tabew<CR>
noremap <leader>ve :tabnew<CR>:e ~/.dotfiles/.nvimrc<CR>
noremap <leader>vh :vnew<CR>:r !grep -rh map ~/.dotfiles/.nvimrc<CR>:setf vim<CR>
noremap <leader>vw :w<CR>
noremap <leader>vq :q<CR>
noremap <leader>vsv :vsp<CR>
noremap <leader>vsh :sp<CR>

" JS/TS
noremap <leader>jt :TSType<CR>
noremap <leader>jd :TSGetDiagnostics<CR>

" Files
noremap <leader>ft :NERDTreeToggle<CR>
noremap <leader>ff :NERDTreeFind<CR>
noremap <leader>fg :Goyo<CR>

" Git
noremap <leader>gb :ToggleBlameLine<CR>
noremap <leader>gm :GitMessenger<CR>

" Help / Utils
noremap <leader>hs <Plug>(openbrowser-smart-search)


" use arrow key to navigate windows
noremap <Down> <C-W>j
noremap <Up> <C-W>k
noremap <Left> <C-W>h
noremap <Right> <C-W>l
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

" automatically clean trailing whitespaces on save
autocmd bufwritepre *.* :call <sid>striptrailingwhitespaces()
