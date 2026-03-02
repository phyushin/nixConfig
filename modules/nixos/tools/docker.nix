{ config, pkgs, lib, ... }:

{
  # ------------------------------------------------------------
  # Docker + OCI Containers base module
  # ------------------------------------------------------------
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Optional: allow your user to run docker without sudo
  users.users.johnze.extraGroups = [ "docker" ];

  # OCI containers backend
  virtualisation.oci-containers = {
    backend = "docker";
  };

  # ------------------------------------------------------------
  # Import docker-managed services (modular)
  # Add more later e.g. ./bloodhound.nix
  # ------------------------------------------------------------
  imports = [
    ./nessus-svc.nix
    # ./bloodhound.nix
  ];
}
