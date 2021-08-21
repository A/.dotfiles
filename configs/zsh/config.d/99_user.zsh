CDPATH=~/Dev/

alias ..="cd ..;"
alias :q=exit
alias nv="docker run --rm -it -v "${HOME}/Dev/@A/.dotfiles/configs/nvim:/root/.config/nvim:rw" -v "${PWD}:/src:rw" --cpus=3 --memory=3g shuva1ov/nvim-lsp"
alias nvlsp="docker run --rm -it -v "${HOME}/Dev/@A/.dotfiles/configs/nvim:/user/.config/nvim:rw" -v "${PWD}:/src:rw" -v "${HOME}/.nvim-cache:/user/.local/share:rw" --cpus=2 -m 4g shuva1ov/nvim-lua"
