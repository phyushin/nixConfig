{ pkgs-unstable }:
{
  lib,
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs-unstable; [
    android-studio
    bruno
    (burpsuite.override { proEdition = true; })
    jsubfinder
    massdns
    netexec
    nixfmt
    nuclei
    platformio
    postman
    python313
    shuffledns
    subfinder
    vscode
  ];
}
