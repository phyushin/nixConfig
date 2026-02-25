{
  description = "Pentesting Setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    headplane = {
      url = "github:tale/headplane/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, headplane, ... }@inputs:
    let
      system = "x86_64-linux";
      # system = "aarch64-darwin" ## APPLE SILICON
      # system = "x86_64-darwin"  ## APPLE INTEL
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      # Unstable pkgs
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

    in
    {
      nixosConfigurations = {
        shinji = nixpkgs.lib.nixosSystem {
          inherit system pkgs;

          modules = [
            ((import ./hosts/default/configuration.nix) { inherit pkgs-unstable; })
            ((import ./modules) { inherit pkgs-unstable; })
          ];
        };
      };
    };
}