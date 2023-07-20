#!/bin/zsh

FZF_WORKING_DIR=~/Dev/@A/notes \
FZF_PROMPT="Notes" \
RG_ARGS="-g '*.{md}'" \
FZF_EXEC="$EDITOR" \
  zsh ~/.bin/fzf-search/_main.sh

