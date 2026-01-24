{ pkgs-unstable }:
{lib,config,pkgs, ...}:
#let unstable-pkgs = import <nixos-unstable> { config = { allowUnfree = true; }; };
{
environment.systemPackages = with pkgs-unstable; [
  nixfmt
  python313
  bruno
  (burpsuite.override { proEdition = true; })    
  android-studio
  nuclei
  platformio
  postman
  netexec
  ];
}