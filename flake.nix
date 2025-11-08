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
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
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

          # Import home-manager NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs stateVersion hostname username system;
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
