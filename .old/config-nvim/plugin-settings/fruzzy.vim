let g:fruzzy#usenative = 1
" call denite#custom#source('_', 'matchers', ['matcher/fruzzy'])
let g:ctrlp_match_func = {'match': 'fruzzy#ctrlp#matcher'}
let g:ctrlp_match_current_file = 1
