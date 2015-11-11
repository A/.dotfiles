# Setup locale
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8

# Setup ZSH
ZSH=$HOME/.oh-my-zsh
COMPLETION_WAITING_DOTS="true"
plugins=(git osx npm github)

# Add ssh key for vargant machines
ssh-add ~/.ssh/id_rsa 2> /dev/null

# Add sourses
export DOTFILES=$HOME/.dotfiles

source $DOTFILES/.exports
source $ZSH/oh-my-zsh.sh
source $DOTFILES/.aliases
source $DOTFILES/lib/emo/prompt.zsh

type rbenv > /dev/null && eval "$(rbenv init -)"
type mux > /dev/null && test -z $TMUX && mux dotfiles
