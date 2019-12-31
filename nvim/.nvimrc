let dotfiles=$DOTFILES
exec "so" dotfiles . '/nvim/settings.vim'
exec "so" dotfiles . '/nvim/plugins.vim'
exec "so" dotfiles . '/nvim/utils.vim'


call SetBackgroundMode()
call timer_start(3000, "SetBackgroundMode", {"repeat": -1})

let mapleader = " "

" Vim
noremap <leader>vt gt
noremap <leader>vT gT
noremap <leader>vtn :tabew<CR>
noremap <leader>ve :tabnew<CR>:e ~/.dotfiles/nvim/.nvimrc<CR>
noremap <leader>vR :so ~/.config/nvim/init.vim<CR>
noremap <leader>vw :w<CR>
noremap <leader>vq :q<CR>
noremap <leader>vsv :vsp<CR>
noremap <leader>vsh :sp<CR>
noremap <leader>vc :Denite colorscheme<CR>
noremap <leader>vv :vsp<CR>
noremap <leader>vh :sp<CR>

" Code
noremap <leader>cc :TComment<CR>
noremap <leader>cC :TCommentInline<CR>
nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
noremap <leader>cE <Plug>(ale_previous_wrap)
noremap <leader>ce <Plug>(ale_next_wrap)
nmap    <leader>cr  <Plug>(coc-rename)

" Go To
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call ShowDocumentation()<CR>
nnoremap <silent> gh :call ShowDocumentation()<CR>
nnoremap <silent> go :execute OpenBrowserSearch(expand("<cword>"))<CR> " TODO: Why <Plug>(openbrowser-smart-search) is not working?

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


" use S-Arrow keys to navigate both vim and tmux windows
nnoremap <silent> <S-Left> :TmuxNavigateLeft<CR>
nnoremap <silent> <S-Down> :TmuxNavigateDown<CR>
nnoremap <silent> <S-Up> :TmuxNavigateUp<CR>
nnoremap <silent> <S-Right> :TmuxNavigateRight<CR>

imap <C-e> <Plug>(coc-snippets-expand-jump)
