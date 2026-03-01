# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal dotfiles for Arch Linux (primary) and macOS, managed with Ansible. Configs are stored in `configs/` and symlinked to `$XDG_CONFIG_HOME` via the `dotfiles` Ansible role.

## Key Commands

```bash
# Apply all dotfiles (symlinks only)
ansible-playbook dotfiles.yml --tags dotfiles

# Install/update packages for a specific group
ansible-playbook manage_packages.yml --limit=archlinux --tag=hyprland --ask-become-pass

# Install everything (skip fonts example)
ansible-playbook manage_packages.yml --limit=archlinux --skip-tags fonts --ask-become-pass

# Format Neovim Lua files
stylua configs/nvim/
```

## Architecture

### Ansible Structure

- `dotfiles.yml` — Main playbook, imports roles sequentially (homebrew, pacman, aur, zsh, dotfiles, python, yarn, nvim, etc.)
- `manage_packages.yml` — Package management playbook; iterates `packages` list from host vars, filterable by tag
- `host_vars/` — Per-host declarations (archlinux.yml, personal_macos.yml, workstation_macos.yml). Each defines `packages` groups containing pacman/aur/homebrew packages, symlink targets (`links`), systemd services, and user groups
- `roles/` — Ansible roles: `dotfiles` (symlinks), `meta_pacman`, `aur`, `python`, `rust`, `yarn`, `zsh`, `systemd`, `cron`, etc.

### Config Organization

Hyprland and Zsh use a **`config.d/` modular pattern** with numbered prefixes for ordering (00, 10, 20, 50, 90). The main config file sources all modules from `config.d/`.

### Neovim — Dual Instance Setup

Two separate Neovim configurations selected via `NVIM_APPNAME`:

- **`nvim`** (default) — Full development IDE. LazyVim-based with Lazy.nvim, blink-cmp completion, fzf navigation, LSP via Mason (16+ servers), conform formatting, codecompanion
  - Entry: `configs/nvim/init.lua` → requires `core.lazy`, `core.lsp`
  - Plugins: `configs/nvim/lua/plugins/`
  - LSP configs: `configs/nvim/lua/lsp/` and `configs/nvim/after/lsp/`
- **`nvim-notebook`** — Obsidian-like markdown editor. Launched with `NVIM_APPNAME=nvim-notebook nvim`. Stripped-down config with markdown-oxide, neo-tree, fzf

### Custom Scripts

`bin/` contains 60+ utility scripts (waybar helpers, theme switching, media controls, Hyprland integration, git repo sync).

## Conventions

- **Git commits**: Uses conventional commit format. Git aliases exist for types: `git feat`, `git fix`, `git chore`, etc. Supports `-s scope` and `-a` (breaking change) flags
- **Lua formatting**: stylua (config at `configs/nvim/stylua.toml`)
- **Default branch**: `master`
