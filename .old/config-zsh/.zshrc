ssh-add ~/.ssh/id_rsa 2> /dev/null

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
export TERM=screen-256color

ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="norm"

source $ZDOTDIR/.exports
source ~/.exports

setopt inc_append_history
plugins=(git osx npm github yarn zsh-autosuggestions zsh-completions docker docker-compose)

export COMPLETION_WAITING_DOTS="true"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1"
autoload -U compinit && compinit

source $HOME/.oh-my-zsh/oh-my-zsh.sh

source $ZDOTDIR/.aliases
source $ZDOTDIR/prompt.zsh
# source $ZDOTDIR/background_jobs

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
