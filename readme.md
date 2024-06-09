## Dotfiles

Yet another dotfiles repo for macos & arch linux includes things below:

- pacman & aur apps
- homebrew apps
- mas apps
- cron jobs
- python, rust, nodejs global packages
- dotfiles configs
- user management
- systemd service management

Per host configuration is in `host_var` dir.

### Usage

```
ansible-playbook manage_packages.yml.yml --limit=archlinux --tag=hyprland --ask-become-pass
ansible-playbook dotfiles.yml --limit=archlinux --skip-tags fonts --ask-become-pass
```

*Example configuration*:

```yaml
# Dependencies are grouped into packages to simplify management
# Package name can be used as a tag. (see: manage_packages.yml)
packages:
  - name: hyprland
    pacman_packages:
      - name: hyprpaper
        state: latest
      - name: hyprland
        state: latest
      - name: network-manager-applet
        state: latest
      - name: udiskie
        state: latest
      - name: rofi
        state: latest
      - name: networkmanager-openvpn
        state: latest
      - name: mesa-utils
        state: latest
    aur_packages:
      - name: hyprevents-git
        state: latest
      - name: hyprlock-git
        state: latest
      - name: hyprpicker
        state: latest
      - name: hyprprop-git
        state: latest
      - name: uair
        state: latest
      - name: hyprpaper
        state: latest
      - name: blueman-git
        state: latest
      - name: swaync
        state: latest
      - name: wlr-randr
        state: latest
      - name: pasystray-wayland
        state: latest
      - name: swappy
        state: latest

    links:
      - src: "{{ dotfiles_source_dir }}/hypr"
        dest: "{{ configs_home }}/hypr"
      - src: "{{ dotfiles_source_dir }}/waybar"
        dest: "{{ configs_home }}/waybar"
      - src: "{{ dotfiles_source_dir }}/wlogout"
        dest: "{{ configs_home }}/wlogout"

  - name: docker
    pacman_packages:
      - name: docker
        state: latest
      - name: docker-compose
        state: latest
    users:
      - name: "{{ ansible_env.USER }}"
        groups: docker
        append: True
    systemd_services:
      - name: docker.service
        state: started
        enabled: true
        masked: False
        fail_on_error: True
```
