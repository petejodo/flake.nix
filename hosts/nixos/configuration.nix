{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Host-specific configuration
  networking.hostName = "nixos";
}
