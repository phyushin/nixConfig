{
  description = "Pentesting Setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    headplane = {
      url = "github:tale/headplane/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, headplane, lanzaboote, ... }@inputs:
    let
      # system = "aarch64-linux";
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
        gridania = nixpkgs.lib.nixosSystem {
          inherit system pkgs;

          modules = [
            lanzaboote.nixosModules.lanzaboote
            ({ pkgs, lib, ... }: {

            environment.systemPackages = [
              # For debugging and troubleshooting Secure Boot.
              pkgs.sbctl
            ];

            # Lanzaboote currently replaces the systemd-boot module.
            # This setting is usually set to true in configuration.nix
            # generated at installation time. So we force it to false
            # for now.
            boot.loader.systemd-boot.enable = lib.mkForce false;

            boot.lanzaboote = {
              enable = true;
              pkiBundle = "/var/lib/sbctl";
            };
          })
          
            ((import ./hosts/gridania/configuration.nix) { inherit pkgs-unstable; })
            ((import ./modules) { inherit pkgs-unstable; })

          ];
        };
      };
    };
}