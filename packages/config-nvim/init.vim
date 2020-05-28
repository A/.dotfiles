filetype plugin on

let g:config_dir = stdpath('config') . '/'
exec "so " . g:config_dir . 'settings.vim'


" colorscheme trash-polka
colorscheme nord
let g:airline_theme = 'trashpolka'

let mapleader = " "

" Vim
noremap <leader>vt gt
noremap <leader>vT gT
noremap <leader>vtn :tabew<CR>
noremap <leader>ve :tabnew<CR>:e ~/.config/nvim/init.vim<CR>
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
nmap <silent> gF :vsp<CR>gf
nnoremap <silent> K :call ShowDocumentation()<CR>
nnoremap <silent> gh :call ShowDocumentation()<CR>
nnoremap <silent> go :execute OpenBrowserSearch(expand("<cword>"))<CR> " TODO: Why <Plug>(openbrowser-smart-search) is not working?

" Files
noremap <leader>ft :NERDTreeToggle<CR>
noremap <leader>ff :NERDTreeFind<CR>
noremap <leader>fG :Goyo<CR>
noremap <leader>fp :FZF<CR>
noremap <leader>fs :Vgrep
noremap <leader>fS :DeniteCursorWord grep<CR>
noremap <leader>fb :Denite buffer<CR>
nnoremap <leader>fg :g//#<Left><Left>

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

" Notes
nnoremap <leader>nc :Note<CR>
nnoremap <leader>ni :e $NOTES_DIR/index.md<CR>
nnoremap <leader>nt :e $NOTES_DIR/ToDo/index.md<CR>
nnoremap <leader>mp :call mdip#MarkdownClipboardImage()<CR>

nnoremap <leader>ns :Ngrep<Space>

" quickfix navigation
nnoremap <leader><Right> :cn<CR>
nnoremap <leader><Left> :cp<CR>

command! -range Note call NotesCreate(<line1>, <line2>)
command! Vlist botright vertical copen | vertical resize 50
command! -nargs=1 Vgrep grep "<args>" ./**/*
nnoremap <leader>l :Vlist<CR>


imap <C-e> <Plug>(coc-snippets-expand-jump)
