## Applying The Config


cd into the `nixconfig` directory and run the following command

```bash
sudo cp /etc/nixos/hardware-configuration.nix ./.
```

Make the relevant changes in the `modules/nixos/tester.nix` for your user on lines 10 and 20 

Edit the lines 18 and 37 in your `configuration.nix` ( in the current folder )

Edit the `flake.nix` and change `nixosConfigurations.voidsent` to the name of the hostname `nixosConfigurations.<hostnane>`

Once that's done, run the following to apply the configuration to the device where `<hostname>` is the name that you added to the flake.nix

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

This will take the configuration from the current folder and apply it to the machine
