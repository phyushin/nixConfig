#!/bin/sh
# replace .#<hostname> with your host name
nix flake update
sudo nixos-rebuild switch --flake .#gridania 
## sudo rm  /boot/efi/Linux/nixos-generation-3* 