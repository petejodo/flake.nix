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
      bat # `cat` replacement
      fastfetch # terminal intro screen
      fd # `find` replacement 
      fzf # fuzzy finder
      localsend # send files over your local network
      ripgrep # `grep` replacement
      zoxide # `cd` replacement
    ];
  };

  xdg = {
    configFile = {
      "fastfetch".source = "${dotfiles}/fastfetch";
      "helix".source = "${dotfiles}/helix";
    };
  };
}
