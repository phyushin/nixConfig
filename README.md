## NixOS Config

This is my attempt at creating a replicatable build for testing that has _hopefully_ everything you need to go from live CD to up and running in less than an hour - current testing is _around_ 25 mins :)


## Getting Started From Fresh Install
Open the base configuration
```bash
sudo nano /etc/nixos/configuration.nix
```

Add the following packages into the `environment.systemPackages = with pkgs; []` config section

- git
- vscode

Once these are added run `sudo nixos-rebuild switch` to install git and vscode!
Next - clone the repo and CD into the nixConig directory

Then follow the steps below to apply the config


## Applying The Config


cd into the root of the repo directory and run the `copy-hw-config.sh` script or following command:

```bash
sudo cat /etc/nixos/hardware-configuration.nix > ./hosts/default/hardware-configuration.nix
```

This will overwrite the existing hardware configuration (nix needs the file to be tracked by git so ... this is what you do)

Make the relevant changes in the `modules/nixos/tester.nix` for your user on lines 15 and 25 

Edit the lines 23,45 and 101 in your `configuration.nix` ( in the current folder ) to reflect your hostname 

Edit the `flake.nix` and change `voidsent = nixpkgs.lib.nixosSystem` to the name of the config (in this case we're using  hostname) `<hostname> = nixpkgs.lib.nixosSystem` (line 58)

Once that's done, run the following to apply the configuration to the device where `<hostname>` is the name that you added to the flake.nix

## Nessus 

to install nessus sun the fetch nessus script first to get the files `scripts/fetch-nessus.sh`. they arent stored in the repo as they are too big


```bash
sudo nixos-rebuild switch --flake .#$hostname 
```

This will take the configuration from the current folder and apply it to the machine (if it's the first time running it, it will take a little time)

