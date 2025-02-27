CDPATH=~/Dev/

alias ..="cd ..;"
alias :q=exit
alias serve="python -m http.server"
alias fzf-search="locate / | fzf"
alias evim="nvim -u none"
# alias hyprlog="cat /tmp/hypr/$(ls -t /tmp/hypr/ | head -n 1)/hyprland.log"
alias pacheck="comm -12 <(pactree -srl $pkgname | sort) <(pacman -Qq | sort)"
alias speed='for i in {1..3}; do echo "\n\rRetry ${i}:"; speedtest --simple; done'
alias glgo="git log --pretty=oneline --abbrev-commit"
alias hj="zapusk"
alias z="zapusk"
alias wk="watch kubectl"
