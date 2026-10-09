CDPATH=~/Dev/

alias glow-full='glow -w "$(tput cols)"'
alias ..="cd ..;"
alias :q=exit
alias serve="python -m http.server"
alias zathura="env GDK_BACKEND=x11 zathura"  # force XWayland: smoother scroll on Hyprland
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
alias glgo="git log --pretty=format:'%C(green)%ad%Creset %C(yellow)%h%Creset %C(blue)%an%Creset %s' --date=format:'%Y-%m-%d %H:%M'"

glgs() {
  git log --reverse --color=always --shortstat \
    --pretty=format:'%C(green)%ad%Creset %C(yellow)%h%Creset @@S@@%C(blue)%an%Creset %s' \
    --date=format:'%Y-%m-%d %H:%M' "$@" \
  | awk '
    function flush(s){ if(pending!=""){ sub(/@@S@@/, s, pending); print pending; pending="" } }
    /@@S@@/ { flush(""); pending=$0; next }
    /files? changed/ {
      f=ins=del=0
      for(i=1;i<=NF;i++){
        if($i~/^file/)f=$(i-1)
        if($i~/insertion/)ins=$(i-1)
        if($i~/deletion/)del=$(i-1)
      }
      flush(sprintf("\033[90m(\033[0m%s\033[33m\033[0m \033[32m+%s\033[0m \033[31m-%s\033[90m)\033[0m ", f, ins, del))
      next
    }
    { next }
    END{ flush("") }
  '
}
