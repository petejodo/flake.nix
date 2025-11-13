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
      # Tools / Utilities
      bat # `cat` replacement
      btop # `top` replacement
      eza # `ls` replacement
      fastfetch # terminal intro screen
      fd # `find` replacement 
      fzf # fuzzy finder
      localsend # send files over your local network
      ripgrep # `grep` replacement
      starship # shell prompt
      hypridle # idle management daemon
      hyprlock # screen locker
      zoxide # `cd` replacement

      # Languages
      beamPackages.erlang
      beamPackages.elixir
      beamPackages.elixir-ls
      gleam
      zig

      # Non-free / commercial apps
      discord
      spotify
    ];

    file = {
      ".gitconfig".source = "${dotfiles}/git/gitconfig";
      ".gitignore".source = "${dotfiles}/git/gitignore";
      ".ssh/config".source = "${dotfiles}/ssh/config";
    };
  };

  xdg = {
    configFile = {
      "host".source = hostDotfiles;
      "btop".source = "${dotfiles}/btop";
      "fastfetch".source = "${dotfiles}/fastfetch";
      "fish".source = "${dotfiles}/fish";
      "ghostty".source = "${dotfiles}/ghostty";
      "helix".source = "${dotfiles}/helix";
      "hypr".source = "${dotfiles}/hypr";
      "niri".source = "${dotfiles}/niri";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = 250;
      repeat-interval = 25;
    };
  };

  systemd.user.services.hypridle = {
    Unit = {
      Description = "Hypridle idle daemon";
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "DESKTOP_SESSION=niri";
    };
    Service = {
      ExecStart = "${pkgs.hypridle}/bin/hypridle";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
