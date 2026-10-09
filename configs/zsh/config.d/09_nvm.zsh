# System node (/usr/bin/node) is the default everywhere; nvm is opt-in per shell.
# The first `nvm ...` call replaces this stub with the real nvm, then re-runs it.
# Per-project: `cd` there and `nvm use` (reads .nvmrc), e.g. ~/Dev/@TraffiqX/traffiqx.
export NVM_DIR="$HOME/.config/nvm"

nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
