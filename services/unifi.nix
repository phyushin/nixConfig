{
  lib,
  ...
}:

let
  CONFIG = import ../config.nix;
  UNIFI_UID = 8901;
in
{
  users.users.unifi = {
    uid = UNIFI_UID;
    group = "unifi";
    isNormalUser = true;
  };

  users.groups.unifi = {
    gid = UNIFI_UID;
  };

  # journalctl -u podman-unifi -f
  virtualisation.oci-containers.containers.unifi = {
    hostname = "unifi";
    image = "lscr.io/linuxserver/unifi-network-application:latest";
    autoStart = true;
    volumes = [
      "/srv/unifi:/config"
    ];
    environment = {
      PUID = (toString UNIFI_UID);
      PGID = (toString UNIFI_UID);
      TZ = "Etc/UTC";
      MONGO_USER = "unifi";
      MONGO_PASS = lib.strings.trim (builtins.readFile CONFIG.UNIFI_DB_PASSWORD_FILE);
      MONGO_HOST = "localhost";
      MONGO_PORT = "27017";
      MONGO_DBNAME = "unifi";
    };
    extraOptions = [
      "--privileged"
      "--network=host"
    ];
  };

  virtualisation.oci-containers.containers.unifi-db = {
    hostname = "unifi-db";
    image = "docker.io/mongo:4.4.29";
    autoStart = true;
    volumes = [
      "/srv/unifi-db/data:/data/db"
      "/srv/unifi-db/init-mongo.js:/docker-entrypoint-initdb.d/init-mongo.js"
    ];
    environment = {
      MONGO_INITDB_ROOT_USERNAME = "unifi";
      MONGO_INITDB_ROOT_PASSWORD = lib.strings.trim (builtins.readFile CONFIG.UNIFI_DB_PASSWORD_FILE);
    };
    extraOptions = [
      "--privileged"
      "--network=host"
    ];
  };

  services.nginx = {
      virtualHosts = {
      "unifi-admin.int.phyubox.com" = {
        useACMEHost = "phyubox.com";
        forceSSL = true;

        locations."/" = {
          proxyPass = "https://127.0.0.1:8443";
          recommendedProxySettings = true;
          extraConfig = CONFIG.LOCAL_NETWORK;
        };
      };
    };
  };

  system.activationScripts.initUnifi = ''
    mkdir -p                                              /srv/unifi
    mkdir -p                                              /srv/unifi-db
    chown -R ${toString UNIFI_UID}:${toString UNIFI_UID}  /srv/unifi
    chmod -R u+rw,g+rw,o-rw                               /srv/unifi
  '';
}
