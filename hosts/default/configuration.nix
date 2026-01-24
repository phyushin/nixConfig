# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs-unstable }:

{ config, pkgs, inputs,  ... }:
#let unstable-pkgs = import nixos-unstable { config = { allowUnfree = true; }; };
#in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # inputs.home-manager.nixosModules.default
    ];

  tester ={
    enable = true;
    userName = "phyu";
  };

  # Bootloader.
  boot ={
    loader ={ 
      grub.enable = true;
      grub.device = "/dev/sda";
      grub.useOSProber = true;
    };
    blacklistedKernelModules = [ "rtl8xxxu" ];
    extraModulePackages = with config.boot.kernelPackages; [
        rtl88xxau-aircrack
    ];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking = {
    hostName = "voidsent"; # Define your hostname.
  # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # proxy.default = "http://user:password@proxy:port/";
  # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking networkmanager.enable = true;
    firewall = {
        enable = true;
        allowedTCPPorts = [22 80 443 8000 8080 8083 27042 3128 5930 ]; # specified open ports http, https, burp listener and frida
      }; 
      extraHosts =
    ''
      127.0.0.2 other-localhost
    '';
  };
  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
    };
  };


  security.rtkit.enable = true;


services ={
    openssh = {
    enable = true;
      ports = [ 22 ];
      settings ={
          PasswordAuthentication = true;
          AllowUsers = [ "phyu" ];
          UseDns = true;
          X11Forwarding = false;
          PermitRootLogin = "prohibit-password";
      };
  };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;
      # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    xserver.enable = true;
  
  # Enable the KDE Plasma Desktop Environment.
  #  displayManager.sddm.enable = true;
  #  desktopManager.plasma6.enable = true;

    xserver.displayManager.lightdm.enable = true;
    xserver.desktopManager.cinnamon.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # xserver.libinput.enable = true;

    #programs.hyprland.enable = true;

    # Configure keymap in X11
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
};

  # Install firefox.
  programs ={
    firefox.enable = true;
    zsh.enable = true;
  };
 
  # List packages installed in system profile. To search, run:
  # $ nix search wget
environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    apktool
    apksigner
    android-tools
    altair
    awscli
    bloodhound
    bluez 
    bluez-tools 
    chromedriver 
    chromium
    chrony
    dalfox
    dbeaver-bin
    dig
    dirb
    dirbuster
    docker
    enum4linux-ng
    ffuf
    #frida-tools
    flameshot
    gcc
    git
    go
    gowitness
    gdb
    hyprland
    jadx    
    jdk11
    jq
    imhex
    kitty
    libgcc
    libimobiledevice
    libxslt
    libreoffice-qt6-fresh    
    neo4j
    neovim
    nikto
    nmap
    nodejs
    obsidian
    open-vm-tools
    openvpn
    openssl
    opentofu
    postman
    ruby
    rgbds
    samdump2
    sameboy
    scrcpy
    spice-vdagent
    terraform
    tmux
    toybox
    veracrypt
    vscode
    vscode-extensions.ms-dotnettools.csdevkit
    vscode-extensions.ms-dotnettools.vscode-dotnet-runtime
    wget
    wifite2
    winetricks
    wineWowPackages.stable
    uv
    zsh

#python
    python313
    python313Packages.pipx
    python313Packages.pandas    
    python313Packages.pip
    python313Packages.numpy
    python313Packages.requests
    python313Packages.wcwidth
#    python3Packages = pkgs.python312Packages;

#unstable
    pkgs-unstable.bruno
    # (unstable-pkgs.burpsuite.override { proEdition = true; })    
    # unstable-pkgs.android-studio
    # unstable-pkgs.nuclei
    # unstable-pkgs.platformio
    # unstable-pkgs.postman
    # unstable-pkgs.netexec
  ];
#  programs.hyprland = {
#   enable = true;
# set the flake package
#  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  # make sure to also set the portal package, so that they are in sync
# portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
#};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {

  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

home-manager = {
	# specialArgs = {inherit inputs;};
	users = {
		"phyu" = import ./home.nix;
	};
};
  # Open ports in the firewall.
  networking= {
    
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # Enable VMware Tools

  virtualisation = {
    vmware.guest.enable = true;
    docker.enable = true;
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
 # programs.hyprland.enable = true;
}
