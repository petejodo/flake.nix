{ config, pkgs, lib, stateVersion, hostname, username, ... }:

{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = stateVersion;

  # Home directory path
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # User-specific packages
  home.packages = with pkgs; [
    # Add user packages here
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Home Manager can manage your shell and other dotfiles
  # Example: programs.bash.enable = true;
}
