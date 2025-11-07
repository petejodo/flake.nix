{ config, pkgs, lib, ... }:

{
  # Define user account
  users.users.peter = {
    isNormalUser = true;
    description = "Peter Jodogne";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # User-specific packages go here
    ];
  };

  # Enable automatic login
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "peter";

  # Workaround for GNOME autologin
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
