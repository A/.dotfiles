let dotfiles=$DOTFILES
exec "so" dotfiles . '/nvim/settings.vim'
exec "so" dotfiles . '/nvim/plugins.vim'
exec "so" dotfiles . '/nvim/utils.vim'

set updatetime=750

" Update colorscheme based on dark/light interface style
let g:colorschemeDark  = 'trash-polka'
let g:colorschemeLight = 'trash-polka-light'
let g:airline_theme = 'monochrome'

call SetBackgroundMode()
call timer_start(3000, "SetBackgroundMode", {"repeat": -1})


let mapleader = " "

" Vim
noremap <leader>vt gt
noremap <leader>vT gT
noremap <leader>vtn :tabew<CR>
noremap <leader>ve :tabnew<CR>:e ~/.dotfiles/nvim/.nvimrc<CR>
noremap <leader>vR :so ~/.config/nvim/init.vim<CR>
noremap <leader>vh :vnew<CR>:r !grep -rh map ~/.dotfiles/.nvimrc<CR>:setf vim<CR>
noremap <leader>vw :w<CR>
noremap <leader>vq :q<CR>
noremap <leader>vsv :vsp<CR>
noremap <leader>vsh :sp<CR>
noremap <leader>vc :Denite colorscheme<CR>

" Code
noremap <leader>cc :TComment<CR>
noremap <leader>cC :TCommentInline<CR>
noremap <leader>co :Denite outline<CR>
noremap <leader>ct :CloseIt<CR>
noremap <leader>cE <Plug>(ale_previous_wrap)
noremap <leader>ce <Plug>(ale_next_wrap)

" JS/TS:
noremap <leader>jt :TSType<CR>
noremap <leader>jd :ALEGoToDefinition<CR>
noremap <leader>jr :ALEFindReferences<CR>
noremap <leader>jc :ImportCost<CR>
noremap <leader>jr :ALEFindReferences<CR>
" noremap <leader>jt :TestNearest<CR>
" noremap <leader>jT :TestVisit<CR>


" Files
noremap <leader>ft :NERDTreeToggle<CR>
noremap <leader>ff :NERDTreeFind<CR>
noremap <leader>fg :Goyo<CR>
noremap <leader>fp :CtrlP<CR>
noremap <leader>fs :Denite grep<CR>
noremap <leader>fS :DeniteCursorWord grep<CR>
noremap <leader>fb :Denite buffer<CR>

" Git
noremap <leader>gb :ToggleBlameLine<CR>
noremap <leader>gm :GitMessenger<CR>
noremap <leader>ga :GBlame<CR>
noremap <leader>gh :GBrowse<CR>
noremap <leader>gi :Denite gists<CR>
noremap <leader>gf :Denite gitlog<CR>
noremap <leader>gl :Denite gitlog:all<CR>
noremap <leader>gs :Denite gitstatus<CR>
noremap <leader>gb :Denite gitbranch<CR>

" Help / Utils
noremap <leader>hs :execute OpenBrowserSearch(expand("<cword>"))<CR> " TODO: Why <Plug>(openbrowser-smart-search) is not working?


" use arrow key to navigate windows
noremap <Down> <C-W>j
noremap <Up> <C-W>k
noremap <Left> <C-W>h
noremap <Right> <C-W>l
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

