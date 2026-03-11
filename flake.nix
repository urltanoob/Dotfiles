{
  description = "NixOS configuration flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ...}@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    username = "urltanoob";
  in
  {
    nixosConfigurations = {
      puter = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/core/configuration.nix
          ./hosts/puter/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username} = import ./modules/home/home.nix;
              extraSpecialArgs = { 
                hostname = "puter";
              };
            };
          }
        ];
        specialArgs = { 
          hostname = "puter";
        };
      };
      
      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/core/configuration.nix
          ./hosts/laptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username} = import ./modules/home/home.nix;
              extraSpecialArgs = { 
                hostname = "laptop";
              };
            };
          }
        ];
        specialArgs = { 
          hostname = "laptop";
        };
      };
    };
  };
}
