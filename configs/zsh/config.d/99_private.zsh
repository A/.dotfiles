# Private companion snippets, linked to ~/.config/zsh/private.d from a separate
# repo (see CLAUDE.md, "Private companion repo"). Completions there are fpath
# autoloads: this runs before oh-my-zsh's compinit, so compdef is not available yet.
if [[ -d ${HOME}/.config/zsh/private.d ]]; then
  [[ -d ${HOME}/.config/zsh/private.d/completions ]] && fpath+=(${HOME}/.config/zsh/private.d/completions)
  for f (${HOME}/.config/zsh/private.d/*.zsh(N.)) . $f
fi
