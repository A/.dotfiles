#!/bin/zsh

RG_PREFIX="rg --column --no-heading --hidden --color=always $RG_ARGS "
INITIAL_QUERY="${*:-}"

FZF_WORKING_DIR=${FZF_WORKING_DIR:-~}
cd $FZF_WORKING_DIR

read -r selected < <(
  FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
  fzf --ansi \
      --exact \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --disabled --query "$INITIAL_QUERY" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
      --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+clear-query+rebind(ctrl-r)" \
      --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)" \
      --prompt "$FZF_PROMPT> " \
      --delimiter : \
      --header "$FZF_PROMPT: ╱ CTRL-R (Ripgrep mode) ╱ CTRL-F (fzf mode) ╱" \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'\
)

if [ -n "${selected[0]}" ]; then
  FILE=$(echo "$selected" | cut -d ':' -f1)
  FILE=$(echo "${FZF_WORKING_DIR}/${FILE}")

  zsh -c "$FZF_EXEC '$FILE'"
fi

