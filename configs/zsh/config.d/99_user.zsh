CDPATH=~/Dev/

alias ..="cd ..;"
alias :q=exit
alias nv="docker run --rm -it -v "${HOME}/Dev/@A/.dotfiles/configs/nvim:/root/.config/nvim:rw" -v "${PWD}:/src:rw" --cpus=2 -m 3g shuva1ov/nvim-lsp"
