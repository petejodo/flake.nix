{
  description = "Peter's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      mkHost = hostname: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system.nix
          ./home.nix
          ./hosts/${hostname}/configuration.nix
        ];
      };
    in {
      nixosConfigurations = {
        beelink-dark = mkHost "beelink-dark";
      };
    };
}