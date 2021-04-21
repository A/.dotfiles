__prompt_command() {
  local curr_exit="$?"
  PROMPT=" %2d% %{$fg_no_bold[blue]%} ❯ %{$reset_color%}"
  if [ "$curr_exit" != 0 ]; then
    PROMPT=" %2d% %{$fg_no_bold[red]%} ❯ %{$reset_color%}"
  fi
}
PROMPT_COMMAND=__prompt_command
precmd() { eval "$PROMPT_COMMAND" }
