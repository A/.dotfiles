let g:airline#themes#monochrome#palette = {}

function! airline#themes#monochrome#refresh()
  let s:SL = airline#themes#get_highlight('StatusLine')
  let s:SLNC = airline#themes#get_highlight('StatusLineNC')
  let s:ERR = airline#themes#get_highlight('ErrorMsg')

  let g:airline#themes#monochrome#palette.normal = airline#themes#generate_color_map(s:SL, s:SLNC, s:SLNC)
  let g:airline#themes#monochrome#palette.insert = g:airline#themes#monochrome#palette.normal
  let g:airline#themes#monochrome#palette.replace = g:airline#themes#monochrome#palette.normal
  let g:airline#themes#monochrome#palette.visual = g:airline#themes#monochrome#palette.normal
  let g:airline#themes#monochrome#palette.normal.airline_error   = s:ERR
  let g:airline#themes#monochrome#palette.normal.airline_warning = s:SLNC
  let g:airline#themes#monochrome#palette.normal.airline_term    = s:SL

  let g:airline#themes#monochrome#palette.inactive = airline#themes#generate_color_map(s:SLNC, s:SLNC, s:SLNC)
endfunction

call airline#themes#monochrome#refresh()
