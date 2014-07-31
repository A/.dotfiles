# Path to your oh-my-zsh configuration.
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
COMPLETION_WAITING_DOTS="true"
plugins=(git osx)
source $ZSH/oh-my-zsh.sh
source $HOME/.dotfiles/.aliases

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="~/.bin:$PATH"
export PATH="/usr/local/share/npm/bin/:$PATH"
export NODE_ENV=development
