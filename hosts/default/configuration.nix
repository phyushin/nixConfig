# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs-unstable }:

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    
    # inputs.home-manager.nixosModules.default
  ];

  tester = {
    enable = true;
    userName = "johnze";
  };

  # Bootloader.
  boot = {
    loader = {
      grub.enable = true;
      grub.device = "/dev/sda";
      grub.useOSProber = true;
    };
    blacklistedKernelModules = [ "rtl8xxxu" ];
    extraModulePackages = with config.boot.kernelPackages; [
      rtl88xxau-aircrack
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking = {
    hostName = "melchior"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        8000
        8080
        8083
        27042
        3128
        5930
      ]; # specified open ports http, https, burp listener and frida
    };
    extraHosts = ''
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

  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = false;
        AllowUsers = [ "johnze" ];
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

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;

    # vscode-server.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    #  displayManager.sddm.enable = true;
    #  desktopManager.plasma6.enable = true;

    xserver = {
      # Enable the X11 windowing system.
      # You can disable this if you're only using the Wayland session.
      enable = true;
      # Enable touchpad support (enabled default in most desktopManager).
      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;
      # libinput.enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };

    };

    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };

  programs = {
    firefox.enable = true;
    zsh.enable = true;
    nix-ld.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs = {
  #   mtr.enable = true;
  #   gnupg.agent = {
  #     enable = true;
  #     enableSSHSupport = true;
  #    };
  # };

  # List services that you want to enable:

  #home-manager = {
  #  # specialArgs = {inherit inputs;};
  #  users = {
  #    "johnze" = import ./home.nix;
  #  };
  #};

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
