export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
export TERM=screen-256color
export XDG_CONFIG_HOME=$HOME/.config

ZSH_CONFIG_HOME=$XDG_CONFIG_HOME/zsh
CDPATH=~/Dev/

setopt inc_append_history

__prompt_command() {
  local curr_exit="$?"
  PROMPT=" %2d% %{$fg_no_bold[blue]%} ❯ %{$reset_color%}"
  if [ "$curr_exit" != 0 ]; then
    PROMPT=" %2d% %{$fg_no_bold[red]%} ❯ %{$reset_color%}"
  fi
}
PROMPT_COMMAND=__prompt_command
precmd() { eval "$PROMPT_COMMAND" }

# ZSH ANSIBLE GENERATED CONFIG
# BEGIN ANSIBLE MANAGED BLOCK dotfiles-bin
PATH=/home/a8ka/Dev/@A/.dotfiles/bin:${PATH}
alias ..="cd ..;"
# END ANSIBLE MANAGED BLOCK dotfiles-bin
# BEGIN ANSIBLE MANAGED BLOCK rust
PATH=${PATH}:/home/a8ka/.cargo/bin
# END ANSIBLE MANAGED BLOCK rust
# BEGIN ANSIBLE MANAGED BLOCK nvim-configure
export EDITOR=nvim
export VISUAL=nvim
# END ANSIBLE MANAGED BLOCK nvim-configure
# BEGIN ANSIBLE MANAGED BLOCK nodejs
PATH=${PATH}:$(yarn global bin)
# END ANSIBLE MANAGED BLOCK nodejs
# BEGIN ANSIBLE MANAGED BLOCK zsh-settings
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
# END ANSIBLE MANAGED BLOCK zsh-settings

# END OF ZSH ANSIBLE GENERATED CONFIG

# source user exports
[ -f ~/.exports ] && source ~/.exports

source $HOME/.oh-my-zsh/oh-my-zsh.sh
