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
alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'
alias glaude='ANTHROPIC_AUTH_TOKEN=${GLM_API_KEY} ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" claude --model glm-5.1'
alias aider-glm="aider --config ~/.aider.conf.yml"
alias aider-minimax="aider --config ~/.aider.minimax.conf.yml"
