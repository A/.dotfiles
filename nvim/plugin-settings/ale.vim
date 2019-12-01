let g:ale_sign_error = ' '
let g:ale_sign_warning = ' '
let g:airline#extensions#ale#enabled = 1
let g:ale_open_list = 0
let g:ale_list_window_size = 5
let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'javascript': ['eslint'],
  \ 'typescript': ['eslint'],
\}
