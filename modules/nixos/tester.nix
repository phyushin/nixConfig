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
      default = "phyu";
      description = ''
        username
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      description = "phyu";
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
