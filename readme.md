## Dotfiles

Arch Linux dotfiles provisioned by ansible designed to be easy to manage and config.

### Usage

```
ansible-playbook dotfiles.yml [--tag] # run a special tag
ansible-playbook dotfiles.yml --skip-tags gui # ignore gui-packages
```

### Configuration

Roles configuration is pulled from `vars` directory, tweak this files to achieve desired state.

### App Configs

App configs are stored in `configs/` directory and managed by `dotfiles` role, tagged as `dotfiles`.
Configs are symlinked according to their destinations specified in `vars/dotfiles.yml`

### Packages

Managed packages are specified in `vars/pacman_packages.yml`, `vars/aur_packages.yml`, `vars/cargo_packages.yml`,
and `vars/yarn_packages.yml` accordingly to the package manager they belongs to.

### Cron Jobs

Cron jobs are specified in `vars/cron_jobs.yml`.

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
