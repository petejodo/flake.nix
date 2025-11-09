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
  hostDotfiles =
    config.lib.file.mkOutOfStoreSymlink "${home}/.flake/hosts/${hostname}/config";
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
      btop # `top` replacement
      eza # `ls` replacement
      fastfetch # terminal intro screen
      fd # `find` replacement 
      fzf # fuzzy finder
      localsend # send files over your local network
      ripgrep # `grep` replacement
      starship # shell prompt
      zoxide # `cd` replacement
    ];
  };

  xdg = {
    configFile = {
      "host".source = hostDotfiles;
      "fastfetch".source = "${dotfiles}/fastfetch";
      "fish".source = "${dotfiles}/fish";
      "helix".source = "${dotfiles}/helix";
    };
  };
}
