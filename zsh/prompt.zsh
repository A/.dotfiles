autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats ' %b'
zstyle ':vcs_info:git*' actionformats ' %b|%a'

precmd () { vcs_info }

# fastest possible way to check if repo is dirty
git_dirty() {
  # if error — skip status
  (($?==0)) || return
  # check if we're in a git repo
  command git rev-parse --is-inside-work-tree &>/dev/null || return
  # check if it's dirty
  command test -n "$(git status --porcelain --ignore-submodules ${umode})"
  (($? == 0)) && echo "%{$fg_no_bold[blue]%} ~(˘▾˘~)"
}

# prompt cursor
local pmt_err="%{$fg_bold[red]%}ಠ_ಠ %{$reset_color%}%{$fg_bold[cyan]%}"
local pmt_status=" %{$fg[blue]%}%(?::${pmt_err})❯%{$reset_color%} "

# show user@host if ssh
[[ "$SSH_CONNECTION" != '' ]] && pmt_user="%n%{$fg_no_bold[blue]%}@%m%{$reset_color%} "

# render prompt
PROMPT='${pmt_user}%~%{$fg_bold[blue]%}${vcs_info_msg_0_}$(git_dirty)%{$reset_color%}${pmt_status}'
