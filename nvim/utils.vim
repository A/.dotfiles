" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif


" let g:colorschemeDark  = 'nord'
" let g:colorschemeLight = 'nord-light'

function! SetBackgroundMode(...)
  " dark mode enabled?
  if system("defaults read -g AppleInterfaceStyle") =~ '^Dark'
    execute "colorscheme ". g:colorschemeDark
  else
    execute "colorscheme ". g:colorschemeLight
  endif
endfunction

