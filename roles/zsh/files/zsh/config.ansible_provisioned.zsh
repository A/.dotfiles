# BEGIN ANSIBLE MANAGED BLOCK role/zsh
ZSH_THEME="norm"
ZSH="/home/a8ka/.oh-my-zsh"

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
PATH=${PATH}:/home/a8ka/.cargo/bin
# END ANSIBLE MANAGED BLOCK rust
# BEGIN ANSIBLE MANAGED BLOCK nodejs
PATH=${PATH}:$(yarn global bin)
# END ANSIBLE MANAGED BLOCK nodejs
# BEGIN ANSIBLE MANAGED BLOCK nvim
export EDITOR=nvim
export VISUAL=nvim
# END ANSIBLE MANAGED BLOCK nvim
# BEGIN ANSIBLE MANAGED BLOCK nvim-configure
export EDITOR=nvim
export VISUAL=nvim
# END ANSIBLE MANAGED BLOCK nvim-configure
