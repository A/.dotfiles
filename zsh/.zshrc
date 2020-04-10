ssh-add ~/.ssh/id_rsa 2> /dev/null

# Setup locale
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8


export DOTFILES=$HOME/.dotfiles

ZSH="$HOME/.oh-my-zsh"
ZSH_CONFIGS="$DOTFILES/zsh"
ZSH_THEME="norm"

export COMPLETION_WAITING_DOTS="true"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1"

setopt inc_append_history
plugins=(git osx npm github yarn zsh-autosuggestions zsh-completions zsh-lerna)
autoload -U compinit && compinit


source $HOME/.oh-my-zsh/oh-my-zsh.sh

source $ZSH_CONFIGS/.exports
source $ZSH_CONFIGS/.aliases
source $ZSH_CONFIGS/prompt.zsh
source $ZSH_CONFIGS/background_jobs


if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Plugins Settings

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
