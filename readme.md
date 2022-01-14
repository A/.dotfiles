## Dotfiles

Yet another dotfiles repo for macos & arch linux includes things below:

- pacman & aur apps
- homebrew apps
- mas apps
- cron jobs
- python, rust, nodejs global packages
- dotfiles configs

Per host configuration is in `host_var` dir.

### Usage

```
ansible-playbook dotfiles.yml --limit=macos --tag=homebrew
ansible-playbook dotfiles.yml --limit=linux --skip-tags gui
```

*Example configuration*:

```yaml
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

cargo_gui_packages:
  - name: alacritty
    state: present

# nodejs packages managed by yarn
yarn_packages:
  - name: n
    state: latest

# Python packages
pip2_packages: []
pip3_packages:
  - termgraph
```
