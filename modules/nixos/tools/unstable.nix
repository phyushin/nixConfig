{ pkgs-unstable }:
{
  lib,
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs-unstable; [
    android-studio  # -- doesnt work with aarch64-linux
    bruno
    burpsuite
    # (burpsuite.override { proEdition = true; })
    jsubfinder
    massdns
    nixfmt
    nuclei
    tailscale
  
  
    shuffledns
    subfinder
    vscode
  ];
}
