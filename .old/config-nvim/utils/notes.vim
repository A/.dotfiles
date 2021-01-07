" https://github.com/xolox/vim-notes/blob/e465a0a987dbacdf7291688215b8545f8584d409/autoload/xolox/notes.vim#L249
function! s:get_visual_selection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n") . "\n"
endfunction

function! NotesCreate(...)
  call inputsave()

  let l:sep = '-'
  let name = input('Note name: ')
  let l:fname = expand($NOTES_DIR) . strftime("%F-%H%M") . '-' . join(split(name), '-') . '.md'


  exec "e " . l:fname

  " let selection = s:get_visual_selection()
  " if len(selection) > 0
  "   exec "normal ggO" . l:selection . "\<cr>\<cr>\<esc>G"
  " endif

  call inputrestore()
endfunction
