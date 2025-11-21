{
  config,
  lib,
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
      "niri".source = "${dotfiles}/niri";
      "noctalia".source = "${dotfiles}/noctalia";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = 250;
      repeat-interval = 25;
    };
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "Polkit GNOME authentication agent";
      BindsTo = "niri.service";
      After = "niri.service";
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  systemd.user.services.swayidle = let
    lock = "noctalia-shell ipc call lockScreen lock";
    display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
    swayidle = "${pkgs.swayidle}/bin/swayidle";
  in {
    Unit = {
      Description = "Idle manager for Wayland";
      Documentation = "man:swayidle(1)";
      BindsTo = "niri.service";
      After = "niri.service";
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
    Service = {
      Type = "simple";
      Restart = "always";
      ExecStart = "${swayidle} " +
        "timeout 300 '${lock}' " +
        "timeout 330 '${display "off"}' " +
        "resume '${display "on"}' " +
        "timeout 600 '${pkgs.systemd}/bin/systemctl suspend' " +
        "before-sleep '${lock}'";
    };
  };
}
