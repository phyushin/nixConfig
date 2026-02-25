{ config, pkgs, lib, ... }:

{
  # ------------------------------------------------------------
  # Enable Docker
  # ------------------------------------------------------------
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Optional: allow your user to run docker without sudo
  users.users.johnze.extraGroups = [ "docker" ];

  # ------------------------------------------------------------
  # Nessus Container
  # ------------------------------------------------------------
  virtualisation.oci-containers = {
    backend = "docker";

    containers.nessus = {
      image = "tenable/nessus:latest-ubuntu";

      # Map host port 8834 → container 8834
      ports = [
        "8834:8834"
      ];

      # IMPORTANT:
      # Persist ONLY the Nessus data directory.
      # Do NOT mount over /opt/nessus entirely.
      volumes = [
        "nessus_data:/opt/nessus/var/nessus"
      ];

      # Auto start via systemd
      autoStart = true;
    };
  };
} 
