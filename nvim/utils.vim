" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif


" let g:colorschemeDark  = 'nord'
" let g:colorschemeLight = 'nord-light'

" TODO: Do not update if current theme is still valid
let s:current_theme = ""

function! SetBackgroundMode(...)
  if system("defaults read -g AppleInterfaceStyle") =~ "^Dark"
    if s:current_theme == "dark" | return "" | endif
    let s:current_theme = "dark"
    execute "colorscheme ". g:colorschemeDark
  else
    if s:current_theme == "light" | return "" | endif
    let s:current_theme = "light"
    execute "colorscheme ". g:colorschemeLight
  endif
endfunction


function! ShowDocumentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
