## Dotfiles

Arch Linux dotfiles provisioned by ansible designed to be easy to manage and config.

### Usage

```
ansible-playbook --list-tags # list all tags
ansible-playbook dotfiles.yml [--tag] # install a special tag
ansible-playbook dotfiles.yml --skip-tags gui # install only cli packages
```

### Configuration

Configuration is pulled from `vars` directory, tweak this files to achieve desired state.

*Example configuration*:

```yaml
# default git configuration
git_config:
  - name: user.name
    value: Anton Shuvalov

# zsh configuration
zsh_ohmyzsh_theme: norm
zsh_ohmyzsh_plugins:
  - name: git
  - name: zsh-autosuggestions
    repo: https://github.com/zsh-users/zsh-autosuggestions
    settings: |
      export COMPLETION_WAITING_DOTS="true"
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1"
zsh_config:
  - name: dotfiles-bin
    block: alias ..="cd ..;"
    state: present

# pacman packages
pacman_packages:
  - name: openssh
    state: latest

pacman_gui_packages:
  - name: telegram-desktop
    state: latest

# aur packages managed by paru
aur_packages:
  - name: tmux-git
    state: latest
aur_gui_packages:
  - name: obsidian-appimage
    state: latest

# rust packages managed by cargo
cargo_packages:
  - name: exa
    state: present # only present or absent

# nodejs packages managed by yarn
yarn_packages:
  - name: n
    state: latest

# Python packages
pip2_packages: []
pip3_packages:
  - termgraph

# nvim configuration
nvim_config: 
  - name: block-name
    state: present
    config: |
      if executable('rg')
        set grepprg=rg\ --color=never\ --vimgrep
      endif

# nvim plugins managed by Vundle
nvim_plugins: 
  - name: 'rhysd/git-messenger.vim'
    state: present
    config: noremap <leader>gm :GitMessenger<CR>
```
