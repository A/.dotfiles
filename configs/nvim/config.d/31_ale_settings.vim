let g:ale_sign_error = ' '
let g:ale_sign_warning = ' '
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#coc#enabled = 1
let g:ale_open_list = 0
let g:ale_list_window_size = 5
let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'javascriptreact': ['prettier'],
  \ 'javascript': ['prettier'],
  \ 'typescriptreact': ['prettier'],
  \ 'typescript': ['prettier'],
  \ 'css': ['prettier'],
\}
let g:ale_linters = {
\   'typescript': ['eslint', 'tsc'],
\   'typescriptreact': ['eslint', 'tsc'],
\   'javascript': ['eslint'],
\   'javascriptreact': ['eslint'],
\}
let g:ale_fix_on_save = 0
let g:ale_linters_explicit = 1
