export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
export TERM=screen-256color
export XDG_CONFIG_HOME=$HOME/.config

ZSH_CONFIG_HOME=$XDG_CONFIG_HOME/zsh

setopt inc_append_history

[ -f $ZSH_CONFIG_HOME/config.ansible_provisioned.zsh ] && source "$ZSH_CONFIG_HOME/config.ansible_provisioned.zsh"
[ -f $ZSH_CONFIG_HOME/prompt.zsh ] && source "$ZSH_CONFIG_HOME/prompt.zsh"

# source user exports
[ -f ~/.exports ] && source ~/.exports


source $HOME/.oh-my-zsh/oh-my-zsh.sh
