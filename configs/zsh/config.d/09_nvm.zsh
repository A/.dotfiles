# export USE_NVM=true
if [ "$USE_NVM" = true ] ; then
  export NVM_DIR=$HOME/.nvm
  nvm_load () { . $NVM_DIR/nvm.sh && . $NVM_DIR/bash_completion; }
  alias node='unalias nvm; unalias node; unalias npm; nvm_load; node $@'
  alias npm='unalias nvm; unalias node; unalias npm; nvm_load; npm $@'
  alias nvm='unalias nvm; unalias node; unalias npm; nvm_load; nvm $@'
fi

# if [ "$USE_NVM" = true ] ; then
#   export NVM_DIR="$HOME/.nvm"
#   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#   [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# fi
