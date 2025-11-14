{ inputs, config, pkgs, lib, username, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Time zone and locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Desktop Environment
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # GNOME Keyring
  services.gnome.gnome-keyring.enable = true;

  # XDG Desktop Portal configuration for Niri + GNOME
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gnome" "gtk" ];
      };
      niri = {
        default = [ "gnome" "gtk" ];
      };
    };
  };

  # User configuration
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };
  users.defaultUserShell = pkgs.fish;
  environment.enableAllTerminfo = true;
  environment.shells = [pkgs.fish pkgs.bash];

  # Enable automatic login
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = username;

  # Workaround for GNOME autologin
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Printing
  services.printing.enable = true;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.iosevka-term
      nerd-fonts.caskaydia-cove
    ];
  };

  programs = {
    niri.enable = true;
    firefox.enable = true;

    command-not-found.enable = false;
    nix-index-database.comma.enable = true; # Try out packages w/o installing, type `, <package-name>`
    steam.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;

    fish.enable = true;
  };

  # Nix settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System packages
  environment.systemPackages = with pkgs; [
    git
    claude-code
    ghostty
    adwaita-icon-theme
    helix

    # Wayland utilities
    xwayland-satellite

    # Sound / Bluetooth related
    bluez
    bluez-tools
    alsa-utils

    # Polkit authentication agent
    polkit_gnome

    # Shell for Niri
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # System version
  system.stateVersion = "25.05";
}
