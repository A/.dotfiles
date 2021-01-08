export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
export TERM=screen-256color
export XDG_CONFIG_HOME=$HOME/.config

setopt inc_append_history

[ -f ./ansible_provisioned ] && source "./config.ansible_provisioned.zsh"
[ -f ./prompt.zsh ] && source "./prompt.zsh"

# source user exports
[ -f ~/.exports ] && source ~/.exports

source $ZSH/oh-my-zsh.sh
