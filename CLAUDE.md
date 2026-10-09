# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal dotfiles for Arch Linux (primary) and macOS, managed with Ansible. Configs are stored in `configs/` and symlinked to `$XDG_CONFIG_HOME` via the `dotfiles` Ansible role.

## Key Commands

```bash
# Install/update one group (packages, links, services)
ansible-playbook manage_packages.yml --limit=archlinux --tag=hyprland --ask-become-pass

# Install everything (skip fonts example)
ansible-playbook manage_packages.yml --limit=archlinux --skip-tags fonts --ask-become-pass

# Format Neovim Lua files
stylua configs/nvim/
```

## Architecture

### Ansible Structure

- `manage_packages.yml` — The only playbook; iterates the `packages` groups from host vars (plus `private_packages`, see below), each group name is a tag. `manage_package.yml` dispatches a group's keys to the roles
- `host_vars/` — Per-host declarations (archlinux.yml, personal_macos.yml, workstation_macos.yml). Each defines `packages` groups containing pacman/aur/homebrew packages, symlink targets (`links`), systemd services, and user groups
- `roles/` — Ansible roles: `dotfiles` (symlinks), `meta_pacman`, `aur`, `python`, `rust`, `yarn`, `systemd`, `cron`, etc.

### Config Organization

Hyprland and Zsh use a **`config.d/` modular pattern** with numbered prefixes for ordering (00, 10, 20, 50, 90). The main config file sources all modules from `config.d/`.

### Neovim — Dual Instance Setup

Two separate Neovim configurations selected via `NVIM_APPNAME`:

- **`nvim`** (default) — Full development IDE. LazyVim-based with Lazy.nvim, blink-cmp completion, fzf navigation, LSP via Mason (16+ servers), conform formatting, codecompanion
  - Entry: `configs/nvim/init.lua` → requires `core.lazy`, `core.lsp`
  - Plugins: `configs/nvim/lua/plugins/`
  - LSP configs: `configs/nvim/lua/lsp/` and `configs/nvim/after/lsp/`
- **`nvim-notebook`** — Obsidian-like markdown editor. Launched with `NVIM_APPNAME=nvim-notebook nvim`. Stripped-down config with markdown-oxide, neo-tree, fzf

### beets

The `musicbrainz` plugin must be in `plugins` or autotagging finds nothing, and
the genre field is `genres` (2.13 renamed it — `$genre` silently stops expanding
in paths).

### Private Companion Repo

Personal configuration lives in a separate private repo checked out next to this
one (`../.dotfiles-private`). It plugs into the same playbook rather than
duplicating it:

- It is a **second inventory source** with the same host names. Ansible loads its
  `host_vars/`, which define `private_packages` (same schema as `packages`;
  `manage_packages.yml` loops over both, group names are tags) and
  `private_source_dir`. `ansible.cfg` lists it as a second `inventory` entry;
  when the directory is absent ansible warns and runs with the public inventory
  only. Don't use `ANSIBLE_INVENTORY` for this: the env var overrides
  `ansible.cfg` in every other ansible repo on the host.
- Its scripts are linked to `~/.bin-private` (on PATH via `10_path.zsh` when it
  exists), its zsh snippets to `~/.config/zsh/private.d` (sourced by
  `99_private.zsh`), its systemd units straight into `~/.config/systemd/user`.
- Public scripts that need a personal host or URL read it from an environment
  variable first, then from a KEY=VALUE file next to the app's own config,
  `~/.config/<app>/<app>.env`, and have no built-in default. Those files are
  plain files in the private repo, linked by a private group named like the
  public one that installs the script (`waybar`, `misc-scripts`).

Rule: anything that references LAN hosts or IPs, personal self-hosted services,
personal repos, or personal agent tooling goes into the private repo. This repo
must stay installable by anyone with only the public inventory.

### Custom Scripts

`bin/` contains 60+ utility scripts (waybar helpers, theme switching, media controls, Hyprland integration, git repo sync).

## Conventions

- **Hyprland binds**: everything after `exec,` is the command, so an inline
  `# comment` on a bind line silently breaks it.
- **Git commits**: Uses conventional commit format. Git aliases exist for types: `git feat`, `git fix`, `git chore`, etc. Supports `-s scope` and `-a` (breaking change) flags
- **Lua formatting**: stylua (config at `configs/nvim/stylua.toml`)
- **Default branch**: `master`
