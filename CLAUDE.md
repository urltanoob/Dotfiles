# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

NixOS flake-based system configuration for two machines (`puter` and `laptop`) with Home Manager integration. Uses Hyprland (Wayland compositor), pywal theming, and a shared module system. User: `urltanoob`, architecture: `x86_64-linux`, channel: `nixos-unstable`.

## Commands

```bash
# Rebuild system (uses zsh alias defined in modules/home/zsh/default.nix)
rebuild
# Equivalent to:
sudo nixos-rebuild switch --flake ~/nixos-config

# Update flake inputs and rebuild
update

# Garbage collect old generations and rebuild
garbage

# Fresh install on a new machine
nixos-install --root /mnt --flake .#<hostname>
```

## Architecture

**Flake entry point:** `flake.nix` defines two `nixosConfigurations` (`puter`, `laptop`). Each composes shared modules + host-specific overrides. The `hostname` variable is passed via `specialArgs` / `extraSpecialArgs` to both NixOS and Home Manager modules.

**Module layers:**

- `modules/core/` — Shared NixOS system config (boot, networking, services, system packages, display manager)
- `modules/home/` — Shared Home Manager modules, each in its own directory with `default.nix`
- `hosts/<hostname>/` — Per-host overrides: `configuration.nix` (imports `hardware-configuration.nix`), `home.nix`, and `hyprland/` configs

**Home Manager** is integrated as a NixOS module (not standalone). `modules/home/home.nix` is the entry point — it dynamically imports the host-specific `home.nix` via `(../../hosts + "/${hostname}/home.nix")`.

**Hyprland config composition:** Each host has a `*-sources.conf` that sources the shared `modules/home/hyprland/hyprland.conf` base config, then the host-specific `*-hyprland.conf` overlay. These are plain Hyprland config files (not Nix-managed).

**Theming:** pywal generates color schemes cached at `~/.cache/wal/`. Colors are sourced into Hyprland (`colors-hyprland.conf`), zsh (`sequences`, `colors-tty.sh`), and wofi (`colors-wofi.css`).

## Key Conventions

- Each Home Manager module lives in `modules/home/<name>/default.nix`
- System-level packages go in `modules/core/system-packages.nix`; user packages go in `modules/home/home.nix`
- Host-specific config should go under `hosts/<hostname>/`, not in shared modules
- Display manager is `ly` (not SDDM, though SDDM config exists commented out)
