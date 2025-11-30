{
  description = "Peter's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nixos-hardware provides some predefined configuration for specific laptop
    # models, CPUs and so on.
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Use home-manager as a flake
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Speed up nixpkgs searches by using a prebuilt database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-index-database, ... } @ inputs:
    let
      stateVersion = "25.05";
      username = "peter";
      system = "x86_64-linux";

      mkHost = hostname: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs stateVersion hostname username system;
        };
        modules = [
          ./system.nix
          ./hosts/${hostname}/configuration.nix

          # All inputs that provide extra modules go here.
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager

          # Fix for termbench-pro build failure (https://github.com/NixOS/nixpkgs/issues/465358)
          # This applies the fix from https://github.com/NixOS/nixpkgs/pull/465400
          {
            nixpkgs.overlays = [
              (final: prev: {
                termbench-pro = prev.termbench-pro.overrideAttrs (oldAttrs: {
                  buildInputs = [
                    final.fmt
                    (final.glaze.override { enableSSL = false; })
                  ] ++ (builtins.filter (pkg: pkg != prev.fmt && pkg != prev.glaze) (oldAttrs.buildInputs or []));
                });
              })
            ];
          }

          # Include home-manager configuration.
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs stateVersion hostname username system;};
              users.${username} = import ./home.nix;
            };
          }
        ];
      };
    in {
      nixosConfigurations = {
        beelink-dark = mkHost "beelink-dark";
      };
    };
}
