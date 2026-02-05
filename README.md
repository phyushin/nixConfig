## NixOS Config

This is my attempt at creating a replicatable build for testing that has _hopefully_ everything you need to go from live CD to up and running in less than an hour - current testing is _around_ 25 mins :)

## Applying The Config


cd into the root of the repo directory and run the `copy-hw-config.sh` script or following command:

```bash
sudo cat /etc/nixos/hardware-configuration.nix > ./hosts/default/hardware-configuration.nix
```

This will overwrite the existing hardware configuration (nix needs the file to be tracked by git so ... this is what you do)

Make the relevant changes in the `modules/nixos/tester.nix` for your user on lines 10 and 20 

Edit the lines 18 and 37 in your `configuration.nix` ( in the current folder ) to reflect your hostname 

Edit the `flake.nix` and change `nixosConfigurations.voidsent` to the name of the hostname `nixosConfigurations.<hostnane>`

Once that's done, run the following to apply the configuration to the device where `<hostname>` is the name that you added to the flake.nix

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

This will take the configuration from the current folder and apply it to the machine (if it's the first time running it, it will take a little time)

