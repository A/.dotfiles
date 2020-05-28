  set laststatus=2

  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif

  let g:airline_powerline_fonts = 0
  let g:airline#extensions#tabline#enabled = 0
  let g:airline#extensions#nerdtree_status = 0
  let g:airline#extensions#tabline#fnamemod = ':t'

  let g:airline_symbols.branch = ''
  let g:airline#extensions#branch#format = 1
  " let g:airline_section_b = g:airline#section#create(['branch', 'hunks'])
  let g:airline_section_x = ''
  let g:airline_section_y = '%{LineNoIndicator()}'
  let g:airline_section_z = '%2c'

  let g:airline_mode_map = {
      \ '__'     : '-',
      \ 'c'      : 'C',
      \ 'i'      : 'I',
      \ 'ic'     : 'I',
      \ 'ix'     : 'I',
      \ 'n'      : 'N',
      \ 'multi'  : 'M',
      \ 'ni'     : 'N',
      \ 'no'     : 'N',
      \ 'R'      : 'R',
      \ 'Rv'     : 'R',
      \ 's'      : 'S',
      \ 'S'      : 'S',
      \ ''     : 'S',
      \ 't'      : 'T',
      \ 'v'      : 'V',
      \ 'V'      : 'V',
      \ ''     : 'V',
      \ }

