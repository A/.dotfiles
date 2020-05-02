let g:airline#themes#trashpolka#palette = {}

function! airline#themes#trashpolka#refresh()

  let s:SL = airline#themes#get_highlight('StatusLine')
  let s:SLNC = airline#themes#get_highlight('StatusLineNC')
  let s:ERR = airline#themes#get_highlight('ErrorMsg')
  let s:WARN = airline#themes#get_highlight('WarningMsg')

  let g:airline#themes#trashpolka#palette.normal = {
  \ 'airline_a': s:SL,
  \ 'airline_b': s:SL,
  \ 'airline_c': s:SLNC,
  \ 'airline_x': s:SLNC,
  \ 'airline_y': s:SL,
  \ 'airline_z': s:SL,
  \ }

  let g:airline#themes#trashpolka#palette.insert = {
  \ 'airline_a': s:WARN,
  \ 'airline_b': s:SL,
  \ 'airline_c': s:SLNC,
  \ 'airline_x': s:SLNC,
  \ 'airline_y': s:SL,
  \ 'airline_z': s:SL,
  \ }

  let g:airline#themes#trashpolka#palette.replace = {
  \ 'airline_a': s:SL,
  \ 'airline_b': s:SL,
  \ 'airline_c': s:SLNC,
  \ 'airline_x': s:SLNC,
  \ 'airline_y': s:SL,
  \ 'airline_z': s:SL,
  \ }

  let g:airline#themes#trashpolka#palette.visual = {
  \ 'airline_a': s:SL,
  \ 'airline_b': s:SL,
  \ 'airline_c': s:SLNC,
  \ 'airline_x': s:SLNC,
  \ 'airline_y': s:SL,
  \ 'airline_z': s:SL,
  \ }

  let g:airline#themes#trashpolka#palette.inactive = {
  \ 'airline_a': s:SLNC,
  \ 'airline_b': s:SLNC,
  \ 'airline_c': s:SLNC,
  \ 'airline_x': s:SLNC,
  \ 'airline_y': s:SLNC,
  \ 'airline_z': s:SLNC,
  \ }


endfunction

call airline#themes#trashpolka#refresh()
