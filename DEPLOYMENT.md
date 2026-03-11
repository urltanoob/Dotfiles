## Deploying This Flake to a New Machine

This guide assumes:
- You want machines named **`puter`** or **`laptop`** as defined in `flake.nix`.
- User **`urltanoob`** should exist and the config repo lives at `~/nixos-config`.
- You have already fixed any outstanding config issues (e.g. Hyprland sources, SMB secrets, AmneziaVPN option, stateVersion).

### 0. Boot Installer & Prepare Disks

1. Boot the NixOS installer ISO (graphical or minimal) on the new machine.
2. Get networking working (usually automatic with NetworkManager on the graphical ISO).
3. Partition and format disks as desired. Example:
   ```bash
   mkfs.vfat -F32 /dev/sda1          # EFI
   mkfs.ext4 /dev/sda2               # root

   mount /dev/sda2 /mnt
   mkdir -p /mnt/boot
   mount /dev/sda1 /mnt/boot
   ```

### 1. Generate Hardware Configuration

From the installer:

```bash
nixos-generate-config --root /mnt
```

This writes `/mnt/etc/nixos/hardware-configuration.nix`.

### 2. Put the Flake on the Target System

1. Ensure `/mnt/home/urltanoob` exists:
   ```bash
   mkdir -p /mnt/home/urltanoob
   ```
2. Get your repo into `/mnt/home/urltanoob/nixos-config`, for example:
   ```bash
   cd /mnt/home/urltanoob
   git clone <your-remote> nixos-config
   ```

### 3. Copy Hardware Config into the Repo

Copy the generated hardware config into the correct host directory:

```bash
cp /mnt/etc/nixos/hardware-configuration.nix \
  /mnt/home/urltanoob/nixos-config/hosts/<HOSTNAME>/hardware-configuration.nix
```

Replace `<HOSTNAME>` with `puter` or `laptop` so it matches the entry in `flake.nix`.

### 4. Check Host Config Structure

In `hosts/<HOSTNAME>/configuration.nix` you should have at least:

```nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
}
```

`flake.nix` should have a matching `nixosConfigurations.<HOSTNAME>` entry that includes:
- `./modules/core/configuration.nix`
- `./hosts/<HOSTNAME>/configuration.nix`
- Home Manager module + user `urltanoob`.

### 5. Install NixOS Using the Flake

From the installer, in `/mnt/home/urltanoob/nixos-config`:

```bash
cd /mnt/home/urltanoob/nixos-config
nixos-install --root /mnt --flake .#<HOSTNAME>
```

Example:

```bash
nixos-install --root /mnt --flake .#laptop
```

Set the root password when prompted. When done:

```bash
reboot
```

Remove the installer media so the system boots from disk.

### 6. First Boot & Repo Location

After reboot:

1. Log in (root or `urltanoob` once available).
2. Ensure the repo exists at `~/nixos-config` for user `urltanoob`. If you installed from another location, you can now:
   ```bash
   su - urltanoob
   git clone <your-remote> ~/nixos-config
   ```

### 7. Rebuild from the Installed System (Sanity Check)

As `urltanoob` on the new system:

```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#<HOSTNAME>
```

Thanks to the zsh alias, you can later just run:

```bash
rebuild
```

### 8. Per-Host Notes

- **`puter`**
  - Uses `hosts/puter/hardware-configuration.nix` and `hosts/puter/configuration.nix`.
  - Hyprland config is composed via `hosts/puter/hyprland/puter-sources.conf` → shared base `modules/home/hyprland/hyprland.conf` plus `hosts/puter/hyprland/puter-hyprland.conf`.

- **`laptop`**
  - Uses `hosts/laptop/hardware-configuration.nix` and `hosts/laptop/configuration.nix`.
  - Hyprland config is composed via `hosts/laptop/hyprland/laptop-sources.conf` → shared base `modules/home/hyprland/hyprland.conf` plus `hosts/laptop/hyprland/laptop-hyprland.conf`.

### 9. Post-Install Checks

On each machine:

- Confirm hostname:
  ```bash
  hostnamectl
  ```
- Test a rebuild:
  ```bash
  sudo nixos-rebuild switch --flake ~/nixos-config#<HOSTNAME>
  ```
- Verify:
  - Hyprland session starts via SDDM.
  - `/mnt/smb-main` mounts correctly (with credentials file, not plain text in Nix).
  - Waybar, pywal, kitty colors look correct.
  - SSH access works as expected.

