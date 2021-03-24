" Remember folding through sessions
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview
au InsertEnter * set nocursorline
au InsertLeave * set cursorline
