" " Close tab if only nerdtree left
autocmd VimEnter *
  \   if !argc()
  \ |   Startify
  \ |   NERDTree
  \ |   wincmd w
  \ | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeShowBookmarks=1
let g:NERDTreeMapOpenSplit="h"
let g:NERDTreeMapOpenVSplit="v"
let g:NERDTreeMapOpenInTab="t"
let NERDTreeHighlightCursorline=0
let g:NERDTreeMapActivateNode="<F4>"
let g:NERDTreeMapPreview="<F3>"
