let mapleader = " "

" Coc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gE :CocCommand eslint.executeAutofix<CR>
nnoremap <silent> K :call ShowDocumentation()<CR>

nmap <leader>rr <Plug>(coc-rename)
nmap <leader>rl <Plug>(coc-codeaction)

" fzf
noremap <leader>fp :Buffers<CR>
noremap <leader>fp :Files<CR>
noremap <leader>fg :RG<Cr>

" NERDTree
noremap <leader>ft :NERDTreeToggle<CR>
noremap <leader>ff :NERDTreeFind<CR>

" tcomment
noremap <leader>cc :TComment<CR>

" vim-fugitive
noremap <leader>gb :GBlame<CR>
noremap <leader>gh :GBrowse<CR>

" git-messenger
noremap <leader>gm :GitMessenger<CR>

" zen-mode
noremap <leader>vm :TZMinimalist<CR>
noremap <leader>vf :TZFocus<CR>

" refactoring
