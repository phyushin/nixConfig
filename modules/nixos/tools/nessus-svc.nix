{ config, pkgs, lib, ... }:

let
  # Where we persist Nessus "users" state on the host
  usersHostDir = "/srv/nessus-users";

  # Marker file to ensure one-time init
  initMarker = "${usersHostDir}/.initialized";

  # Root-only env file holding secrets (NOT stored in nix store)
  envFile = "/etc/nessus-init.env";
in
{
  # ------------------------------------------------------------
  # Nessus container (pinned)
  # ------------------------------------------------------------
  virtualisation.oci-containers.containers.nessus = {
    image = "tenable/nessus:10.11.2-ubuntu"; # Pinned Version
    autoStart = true;

    ports = [
      "8834:8834"
    ];

    # Persist only /users to avoid masking internal runtime layout
    volumes = [
      "${usersHostDir}:/opt/nessus/var/nessus/users"
    ];
  };

  # ------------------------------------------------------------
  # Host directory creation (at boot) with safe permissions
  # ------------------------------------------------------------
  systemd.tmpfiles.rules = [
    # d <path> <mode> <user> <group> <age> <argument>
    "d ${usersHostDir} 0700 root root - -"
  ];

  # ------------------------------------------------------------
  # One-shot init: register + create admin user (only once)
  # ------------------------------------------------------------
  systemd.services.nessus-init = {
    description = "Initialize Nessus (register + admin user) once";
    after = [ "docker.service" "docker-nessus.service" "network-online.target" ];
    requires = [ "docker.service" "docker-nessus.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      # Load secrets safely (license + username + password)
      EnvironmentFile = envFile;

      # Hardening (reasonable defaults)
      User = "root";
      Group = "root";
      NoNewPrivileges = true;

      # Don't make the whole boot fail if Tenable is unreachable right now.
      # We'll handle errors inside the script anyway.
      TimeoutStartSec = 900;
    };

    script = ''
      set -euo pipefail

      echo "[nessus-init] Starting..."

      # If already initialized, do nothing
      if [ -f "${initMarker}" ]; then
        echo "[nessus-init] Marker exists (${initMarker}). Skipping."
        exit 0
      fi

      # Ensure required env vars exist (from ${envFile})
      : "''${NESSUS_CODE:?Missing NESSUS_CODE in ${envFile}}"
      : "''${NESSUS_USER:?Missing NESSUS_USER in ${envFile}}"
      : "''${NESSUS_PASS:?Missing NESSUS_PASS in ${envFile}}"

      # Wait for container to exist
      echo "[nessus-init] Waiting for container 'nessus'..."
      for i in $(seq 1 60); do
        if docker ps --format '{{.Names}}' | grep -qx 'nessus'; then
          break
        fi
        sleep 2
      done

      if ! docker ps --format '{{.Names}}' | grep -qx 'nessus'; then
        echo "[nessus-init] ERROR: Container 'nessus' not running."
        exit 0
      fi

      # Wait for HTTPS endpoint to respond (Nessus can take a while)
      echo "[nessus-init] Waiting for Nessus HTTPS to respond on 127.0.0.1:8834 ..."
      for i in $(seq 1 180); do
        if ${pkgs.curl}/bin/curl -kfsS https://127.0.0.1:8834/ >/dev/null 2>&1; then
          echo "[nessus-init] Nessus web endpoint is responding."
          break
        fi
        sleep 2
      done

      # If it never came up, don't brick the machine — just exit.
      if ! ${pkgs.curl}/bin/curl -kfsS https://127.0.0.1:8834/ >/dev/null 2>&1; then
        echo "[nessus-init] WARNING: Nessus HTTPS did not become ready in time; skipping init."
        exit 0
      fi

      # ---- Registration / plugin fetch (safe) ----
      # Don't repeat if Nessus already looks registered.
      # We'll use a lightweight heuristic: look for an existing users db / state.
      # (We still also rely on marker file to avoid repeats.)
      echo "[nessus-init] Attempting license registration (safe)..."
      if docker exec nessus test -f /opt/nessus/var/nessus/users/users.db >/dev/null 2>&1; then
        echo "[nessus-init] users.db exists; likely already initialized. (Still may not be registered.)"
      fi

      # Try registration; if it fails (network), continue without failing boot.
      if docker exec -i nessus /opt/nessus/sbin/nessuscli fetch --register "''${NESSUS_CODE}"; then
        echo "[nessus-init] Registration/fetch succeeded."
      else
        echo "[nessus-init] WARNING: Registration/fetch failed (network? code?). Continuing."
      fi

      # ---- Create admin user if missing ----
      # If 'nessuscli lsuser' exists, use it. If not, we fall back to trying adduser and tolerating "exists".
      echo "[nessus-init] Checking whether user exists..."
      user_exists=0

      if docker exec nessus /opt/nessus/sbin/nessuscli help 2>/dev/null | grep -qi 'lsuser'; then
        if docker exec nessus /opt/nessus/sbin/nessuscli lsuser 2>/dev/null | awk '{print $1}' | grep -qx "''${NESSUS_USER}"; then
          user_exists=1
        fi
      else
        # Fallback heuristic: check for the username string in users db dump (best-effort)
        if docker exec nessus sh -lc "strings /opt/nessus/var/nessus/users/users.db 2>/dev/null | grep -q \"''${NESSUS_USER}\""; then
          user_exists=1
        fi
      fi

      if [ "$user_exists" -eq 1 ]; then
        echo "[nessus-init] User ''${NESSUS_USER} already exists; skipping adduser."
      else
        echo "[nessus-init] Creating admin user ''${NESSUS_USER}..."
        if docker exec -i nessus /opt/nessus/sbin/nessuscli adduser \
          --username "''${NESSUS_USER}" \
          --password "''${NESSUS_PASS}" \
          --role admin; then
          echo "[nessus-init] User created."
        else
          echo "[nessus-init] WARNING: adduser failed (maybe already exists). Continuing."
        fi
      fi

      # Mark as initialized (persisted on host)
      touch "${initMarker}"
      chmod 0600 "${initMarker}" || true

      echo "[nessus-init] Done."
    '';
  };

  # ------------------------------------------------------------
  # Optional: open firewall if you access Nessus from other hosts
  # Uncomment if needed.
  # ------------------------------------------------------------
  # networking.firewall.allowedTCPPorts = [ 8834 ];
}