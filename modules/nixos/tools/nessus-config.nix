{ config, lib, pkgs, ... }:

let
  cfg = config.my.nessus;
  version = "10.11.2";

  # Select correct installer based on architecture
  src =
    if pkgs.stdenv.hostPlatform.system == "aarch64-linux" then
      ../../../pkgs/nessus/Nessus-${version}-ubuntu1804_aarch64.deb
    else
      ../../../pkgs/nessus/Nessus-${version}-ubuntu1604_amd64.deb;

  # Extract .deb into Nix store
  nessusPkg = pkgs.stdenv.mkDerivation {
    name = "nessus-${version}";
    inherit src;

    nativeBuildInputs = [ pkgs.dpkg ];

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      mkdir extracted
      ${pkgs.dpkg}/bin/dpkg-deb -x $src extracted
    '';

    installPhase = ''
      mkdir -p $out
      cp -r extracted/* $out/
    '';
  };

  # FHS wrapper so proprietary binary runs on NixOS
    nessusFHS = pkgs.buildFHSEnv {
    name = "nessus-env";

    targetPkgs = pkgs: with pkgs; [
      glibc
      zlib
      openssl
      libgcc
      curl
      bash
    ];

    extraMounts = [
      {
        source = "${nessusPkg}/opt/nessus";
        target = "/opt/nessus";
      }
    ];

    runScript = "/opt/nessus/sbin/nessusd";
  };

in
{
  options.my.nessus.enable =
    lib.mkEnableOption "Enable Nessus scanner";

  config = lib.mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [ 8834 ];

  systemd.services.nessus = {
    description = "Nessus vulnerability scanner";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${nessusFHS}/bin/nessus-env";
      Restart = "on-failure";

      Environment = [
        "OPENSSL_CONF="
        "OPENSSL_MODULES="
        "NESSUS_FIPS=0"
        "NESSUS_TZ_DIR=/usr/share/zoneinfo"
      ];
    };
  };


  };
}