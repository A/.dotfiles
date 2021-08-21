CDPATH=~/Dev/

alias ..="cd ..;"
alias :q=exit
alias nv="docker run --rm -it \
  -v "${HOME}/Dev/@A/.dotfiles/configs/nvim:/user/.config/nvim:rw" \
  -v "${PWD}:/src:rw" \
  -v "${HOME}/.nvim-cache:/user/.local/share:rw" \
  --cpus=2 \
  --memory=4g \
  shuva1ov/nvim"
alias serve="python -m http.server"
