#!/bin/zsh

FZF_WORKING_DIR=~ \
FZF_PROMPT="Docs" \
RG_ARGS="-g '*.{md}'" \
FZF_EXEC="$EDITOR" \
  zsh ~/.bin/fzf-search/_main.sh
