let mapleader = " "

" Coc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gE :CocCommand eslint.executeAutofix<CR>
nnoremap <silent> K :call ShowDocumentation()<CR>

" Denite
noremap <leader>gl :Denite gitlog<CR>
noremap <leader>gL :Denite gitlog:all<CR>

" telescope
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fp <cmd>Telescope find_files<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fe <cmd>Telescope file_browser<cr>
nnoremap <leader>fS <cmd>Telescope lsp_workspace_symbols<cr>

nnoremap <leader>vk <cmd>Telescope keymaps<cr>

" fzf
noremap <leader>fP :FZF<CR>

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
