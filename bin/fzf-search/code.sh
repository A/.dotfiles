#!/bin/zsh

FZF_WORKING_DIR=~/Dev/ \
FZF_PROMPT="Code" \
RG_ARGS="-g '*.{js,ts,py,rs,css,html,tsx,jsx,sh,zsh,md}'" \
FZF_EXEC=$EDITOR \
  zsh ~/.bin/fzf-search/_main.sh
