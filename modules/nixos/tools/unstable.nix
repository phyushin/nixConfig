{ pkgs-unstable }:
{lib,config,pkgs, ...}:
#let unstable-pkgs = import <nixos-unstable> { config = { allowUnfree = true; }; };
{
environment.systemPackages = with pkgs-unstable; [
  nixfmt
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  python313

#    python3Packages = pkgs.python312Packages;

# #unstable
  bruno
  (burpsuite.override { proEdition = true; })    
  android-studio
  nuclei
  platformio
  postman
  netexec
  ];
}