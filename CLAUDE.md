# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains a NixOS system configuration using flakes. The configuration defines a complete NixOS system with GNOME desktop environment, targeting the hostname "nixos" on x86_64-linux.

## Architecture

### Flake Structure

The configuration follows a multi-host pattern with shared and host-specific modules:

```
.
├── flake.nix              # Entry point with mkHost helper function
├── system.nix             # Shared system-wide configuration
├── home.nix               # User account configuration
└── hosts/
    └── nixos/
        ├── configuration.nix          # Host-specific settings
        └── hardware-configuration.nix # Auto-generated hardware config
```

**Key Files:**
- **flake.nix**: Defines the flake inputs and a `mkHost` helper function that combines shared modules with host-specific configuration
- **system.nix**: Shared system configuration (bootloader, desktop environment, packages, services) applied to all hosts
- **home.nix**: User account definitions and user-specific settings
- **hosts/<hostname>/configuration.nix**: Host-specific configuration (hostname, custom settings)
- **hosts/<hostname>/hardware-configuration.nix**: Auto-generated hardware settings (do not manually edit)

The `mkHost` function in flake.nix combines system.nix, home.nix, and the host-specific configuration to build each machine's configuration.

This structure is based on this blog post, https://happens.lol/blog/how-to-nixos-insane/. If asked or if anything is unclear about where it should go, use this blog post as a reference as well as the associated github repo, https://github.com/happenslol/flake/.

## Common Commands

### Building and Applying Configuration

```bash
# Build the system configuration (test without applying)
sudo nixos-rebuild build --flake .#beelink-dark

# Build and switch to new configuration
sudo nixos-rebuild switch --flake .#beelink-dark

# Build and make bootable (apply on next boot)
sudo nixos-rebuild boot --flake .#beelink-dark

# Test configuration temporarily (reverts on reboot)
sudo nixos-rebuild test --flake .#beelink-dark
```

### Flake Management

```bash
# Update flake inputs (update nixpkgs)
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Show flake metadata
nix flake show

# Check flake for errors
nix flake check
```

### Package Management

```bash
# Search for packages
nix search nixpkgs <package-name>

# Temporarily run a package without installing
nix run nixpkgs#<package-name>

# Start a shell with specific packages
nix shell nixpkgs#<package-name>
```

## Configuration Details

### Key Settings

- **System**: x86_64-linux
- **Hostname**: nixos
- **Desktop**: GNOME with GDM display manager
- **User**: peter (auto-login enabled)
- **Bootloader**: systemd-boot with EFI
- **Timezone**: America/New_York
- **Experimental features**: nix-command and flakes are enabled
- **Unfree packages**: Allowed

### Modifying Configuration

**System-wide changes** (applies to all hosts):
- Edit `system.nix` for bootloader, desktop environment, services, and system packages
- Edit `home.nix` for user accounts and user-specific settings

**Host-specific changes**:
- Edit `hosts/<hostname>/configuration.nix` for hostname and machine-specific settings
- Hardware-configuration.nix should not be manually modified (auto-generated)

After editing, rebuild with `sudo nixos-rebuild switch --flake .#<hostname>`

### Adding New Hosts

To add a new host:

1. Create a new directory: `mkdir -p hosts/<new-hostname>`
2. Generate hardware configuration on the target machine:
   ```bash
   nixos-generate-config --show-hardware-config > hosts/<new-hostname>/hardware-configuration.nix
   ```
3. Create `hosts/<new-hostname>/configuration.nix`:
   ```nix
   { config, pkgs, lib, ... }:
   {
     imports = [ ./hardware-configuration.nix ];
     networking.hostName = "<new-hostname>";
     # Add host-specific settings here
   }
   ```
4. Add the host to flake.nix:
   ```nix
   nixosConfigurations = {
     nixos = mkHost "nixos";
     new-hostname = mkHost "new-hostname";
   };
   ```
5. Build with: `sudo nixos-rebuild switch --flake .#<new-hostname>`

### Adding New Modules

To add additional configuration modules, create new .nix files in the root directory and add them to the modules list in the `mkHost` function in flake.nix.
