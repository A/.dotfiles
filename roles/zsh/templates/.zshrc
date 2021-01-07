# {{ ansible_managed }}

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
export TERM=screen-256color
export XDG_CONFIG_HOME=$HOME/.config

ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="{{ oh_my_zsh_theme }}"

__prompt_command() {
  local curr_exit="$?"
  PROMPT=" %2d% %{$fg_no_bold[blue]%} ❯ %{$reset_color%}"
  if [ "$curr_exit" != 0 ]; then
    PROMPT=" %2d% %{$fg_no_bold[red]%} ❯ %{$reset_color%}"
  fi
}

PROMPT_COMMAND=__prompt_command
precmd() { eval "$PROMPT_COMMAND" }

setopt inc_append_history

plugins=({% for plugin in oh_my_zsh_plugins %} {{ plugin.name }} {% endfor %})

{%  for plugin in oh_my_zsh_plugins %}
  {% if plugin.settings is defined %}{{ plugin.settings }}{% endif %}
{% endfor %}

source ~/.exports
source $HOME/.oh-my-zsh/oh-my-zsh.sh


{{ placeholder.p1 }}
{{ placeholder.p2 }}
