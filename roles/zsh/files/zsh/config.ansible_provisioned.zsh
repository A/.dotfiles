# BEGIN ANSIBLE MANAGED BLOCK role/zsh
ZSH_THEME="norm"
ZSH="$HOME/.oh-my-zsh"

plugins=( \
git \
npm \
github \
yarn \
zsh-autosuggestions \
zsh-completions \
docker \
docker-compose \
)

export COMPLETION_WAITING_DOTS="true"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1"
autoload -U compinit && compinit
# END ANSIBLE MANAGED BLOCK role/zsh
# BEGIN ANSIBLE MANAGED BLOCK rust
PATH=${PATH}:~/.cargo/bin
# END ANSIBLE MANAGED BLOCK rust
# BEGIN ANSIBLE MANAGED BLOCK nodejs
PATH=${PATH}:~/.yarn/bin
# END ANSIBLE MANAGED BLOCK nodejs
