#!/bin/sh
cat /etc/nixos/hardware-configuration.nix > ./hosts/default/hardware-configuration.nix
echo "hardware-configuration.nix copied!"
