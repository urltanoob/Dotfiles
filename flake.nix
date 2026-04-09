{
  description = "NixOS configuration flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    username = "urltanoob";
    mkHost = hostname: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit hostname; };
      modules = [
        ./modules/core/configuration.nix
        ./hosts/${hostname}/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = import ./modules/home/home.nix;
            extraSpecialArgs = { inherit hostname; };
          };
        }
      ];
    };
  in
  {
    nixosConfigurations = {
      puter  = mkHost "puter";
      laptop = mkHost "laptop";
    };
  };
}
