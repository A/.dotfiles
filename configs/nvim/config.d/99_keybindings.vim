let mapleader = " "

nmap <silent> gF :vsp<CR>gf

" Coc
nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
nmap    <leader>cr  <Plug>(coc-rename)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> ge :lw<CR>
imap <C-e> <Plug>(coc-snippets-expand-jump)
nnoremap <silent> K :call ShowDocumentation()<CR>

" Denite
noremap <leader>fS :DeniteCursorWord grep<CR>
noremap <leader>fb :Denite buffer<CR>
noremap <leader>vc :Denite colorscheme<CR>
noremap <leader>gi :Denite gists<CR>
noremap <leader>gf :Denite gitlog<CR>
noremap <leader>gl :Denite gitlog:all<CR>
noremap <leader>gs :Denite gitstatus<CR>
noremap <leader>gb :Denite gitbranch<CR>
noremap <leader>cE <Plug>(ale_previous_wrap)
noremap <leader>ce <Plug>(ale_next_wrap)
noremap <leader>cE <Plug>(ale_previous_wrap)
noremap <leader>ce <Plug>(ale_next_wrap)

" Denite grep
nnoremap <leader>fs :<C-u>Denite grep:<CR><CR>
nnoremap <leader>fS :<C-u>DeniteCursorWord grep:.<CR>

" fzf
noremap <leader>fp :FZF<CR>

" NERDTree
noremap <leader>ft :NERDTreeToggle<CR>
noremap <leader>ff :NERDTreeFind<CR>

" tcomment
noremap <leader>cc :TComment<CR>
noremap <leader>cC :TCommentInline<CR>

" vim-fugitive
noremap <leader>ga :GBlame<CR>
noremap <leader>gh :GBrowse<CR>

" git-messenger
noremap <leader>gm :GitMessenger<CR>
