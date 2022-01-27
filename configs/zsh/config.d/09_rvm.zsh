[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if command -v rvm &> /dev/null; then
  export PATH="$PATH:$HOME/.rvm/bin"
fi
