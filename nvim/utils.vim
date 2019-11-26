" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif


" let g:colorschemeDark  = '1989'
" let g:colorschemeLight = 'nofrils-light'
function! SetBackgroundMode(...)
  " dark mode enabled?
  if system("defaults read -g AppleInterfaceStyle") =~ '^Dark'
    execute "colorscheme ". g:colorschemeDark
  else
    execute "colorscheme ". g:colorschemeLight
  endif
endfunction

