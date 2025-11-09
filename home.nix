{
  config,
  pkgs,
  stateVersion,
  hostname,
  username,
  ...
}: let
  home = "/home/${username}";
  dotfiles =
    config.lib.file.mkOutOfStoreSymlink "${home}/.flake/config";
in {
  programs = {
    home-manager.enable = true;
  };

  home = {
    inherit stateVersion username;
    homeDirectory = home;

    # User-specific packages
    packages = with pkgs; [
      # Add user packages here
    ];
  };

  xdg = {
    configFile = {
      "fastfetch".source = "${dotfiles}/fastfetch";
      "helix".source = "${dotfiles}/helix";
    };
  };
}
