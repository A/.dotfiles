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


""" Userland Code
"
" Update colorscheme based on dark/light interface style
"
" let g:colorschemeDark  = 'trash-polka'
" let g:colorschemeLight = 'trash-polka-light'
" call SetBackgroundMode()
" call timer_start(3000, "SetBackgroundMode", {"repeat": -1})
