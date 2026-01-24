{
  description = "Pentesting Setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url  = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { 
        allowUnfree = true;
      };
    };
      pkgs-unstable = import nixpkgs-unstable { 
      inherit system;

      config = { 
      allowUnfree = true; 
      }; 
    };
  in
  {
    nixosConfigurations.voidsent= nixpkgs.lib.nixosSystem {
      # specialArgs = {inherit inputs;};
      inherit system pkgs;
      modules = [
        ((import ./hosts/default/configuration.nix ){ inherit pkgs-unstable;})
        ((import ./modules) { inherit pkgs-unstable;})
        
             
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
