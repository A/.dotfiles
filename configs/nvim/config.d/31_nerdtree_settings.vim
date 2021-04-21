let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
let g:NERDTreeDirArrowExpandable = "\u00a0"
let g:NERDTreeDirArrowCollapsible = "\u00a0"

let NERDTreeMinimalUI=1
let g:NERDTreeMapOpenSplit="h"
let g:NERDTreeMapOpenVSplit="v"
let g:NERDTreeMapOpenInTab="t"
let NERDTreeHighlightCursorline=0
let g:NERDTreeMapActivateNode="<F4>"
let g:NERDTreeMapPreview="<F3>"
let g:NERDTreeIgnore = ['^node_modules$']
let g:NERDTreeWinPos = "left"

autocmd VimEnter *
  \   if !argc()
  \ |   NERDTree
  \ |   wincmd w
  \ | endif
autocmd bufenter *
  \ if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
