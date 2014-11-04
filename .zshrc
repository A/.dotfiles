# Setup locale
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8

# Setup ZSH
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
COMPLETION_WAITING_DOTS="true"
plugins=(git osx npm github taskwarrior)

# Add ssh key for vargant machines
ssh-add ~/.ssh/id_rsa 2> /dev/null

# Go
export GOPATH=$HOME

# Add sourses
export DOTFILES=$HOME/.dotfiles
source $DOTFILES/.exports
source $ZSH/oh-my-zsh.sh
source $DOTFILES/.aliases


# Prompt
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_no_bold[magenta]%} ~(˘▾˘~)"
ZSH_THEME_GIT_PROMPT_CLEAN=""

local pmt_ok="%{$fg[blue]%}❯%{$reset_color%}"
local pmt_err="%{$fg_bold[red]%}ಠ_ಠ%{$reset_color%}"
local pmt_status="%(?:${pmt_ok}:${pmt_err})"
[[ "$SSH_CONNECTION" != '' ]] && pmt_user="%{%{$fg_bold[magenta]%}%n@%m %{$reset_color%}"
PROMPT='${pmt_user}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$reset_color%}${pmt_status} '
