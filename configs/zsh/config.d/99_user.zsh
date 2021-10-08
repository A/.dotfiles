CDPATH=~/Dev/

alias ..="cd ..;"
alias :q=exit
alias serve="python -m http.server"
alias fzf-search="locate / | fzf"

alias b="oil"
alias ba="oil -a"
alias bd="oil -d"
alias bt="oil -t"
alias bT="oil -T"

alias speed='for i in {1..3}; do echo "\n\rRetry ${i}:"; speedtest --simple; done'
alias glgo="git log --pretty=oneline --abbrev-commit"
