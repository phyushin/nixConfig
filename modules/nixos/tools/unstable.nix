{ pkgs-unstable }:
{
  lib,
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs-unstable; [
    #android-studio  -- doesnt work with aarch64-linux
    bruno
    (burpsuite.override { proEdition = false; })
    jsubfinder
    massdns
    netexec
    nixfmt
    nuclei
    platformio
    #postman
    shuffledns
    subfinder
    vscode
  ];
}
