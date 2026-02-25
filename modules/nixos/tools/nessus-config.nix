{ config, lib, pkgs, ... }:

let
  cfg = config.my.nessus;

  version = "10.11.2";

src =
  if pkgs.stdenv.hostPlatform.system == "aarch64-linux" then
    ../../../pkgs/nessus/Nessus-${version}-ubuntu1804_aarch64.deb
  else
    ../../../pkgs/nessus/Nessus-${version}-ubuntu1604_amd64.deb;

  nessusPkg = pkgs.stdenv.mkDerivation {
    name = "nessus-${version}";
    inherit src;

    nativeBuildInputs = [ pkgs.dpkg ];

    unpackPhase = ''
      dpkg-deb -x $src $PWD/extracted
    '';

    installPhase = ''
      mkdir -p $out
      cp -r extracted/* $out/
    '';
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
        ExecStart = "${nessusPkg}/opt/nessus/sbin/nessusd";
        Restart = "on-failure";
      };
    };
  };
}