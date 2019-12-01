let g:ctrlp_root_markers = ['package.json', '.gitignore']
let g:ctrlp_user_command = 'find %s -type f | grep -v -e "node_modules" -e "public" -e ".jest" -e ".git" -e "coverage"'
