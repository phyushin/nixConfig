{ pkgs-unstable }:
{
  imports = [
    ./nixos/tester.nix
    ./nixos/tools/docker.nix
    ./nixos/tools/stable.nix
    ((import ./nixos/tools/unstable.nix) { inherit pkgs-unstable; })
    ./nixos/tools/nessus-config.nix # the setup on nessus is a bit more involved so its in a seperate file
  ];
}
