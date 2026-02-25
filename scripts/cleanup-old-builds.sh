#!/bin/sh
sudo nix-collect-garbage --delete-older-than 5d # cleans up buils older than 5days 
