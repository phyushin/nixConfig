{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.tester;
in
{
  options.tester = {
    enable = lib.mkEnableOption "Enable user module";

    userName = lib.mkOption {
      default = "johnze";
      description = ''
        username
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      description = "johnze";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "adbusers"
      ];
      packages = with pkgs; [
        kdePackages.kate
      ];
      shell = pkgs.zsh;
    };
  };
}
