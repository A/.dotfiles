PATH=/opt/homebrew/bin/:${PATH}
PATH=${PATH}:${HOME}/.local/bin
PATH=${PATH}:/usr/local/bin
PATH=${PATH}:${HOME}/.cargo/bin
PATH=${PATH}:${HOME}/.bin
[[ -d ${HOME}/.bin-private ]] && PATH=${PATH}:${HOME}/.bin-private
PATH=${PATH}:$(go env GOPATH)/bin
