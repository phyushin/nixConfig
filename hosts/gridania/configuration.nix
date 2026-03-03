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
  ];

  tester = {
    enable = true;
    userName = "phyu";
  };

  # graphics
  hardware = {
    graphics = {
      enable = true;
    };
    
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of 
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      # Only available from driver 515.43.04+
      open = true;

      # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
};


  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
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
    hostName = "gridania"; # Define your hostname.
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
      192.168.2.21 emerald.local
      192.168.2.5  crystarium.local
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

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;

    # Enable the KDE Plasma Desktop Environment.
    #  displayManager.sddm.enable = true;
    #  desktopManager.plasma6.enable = true;

    xserver = {
      # Enable the X11 windowing system.
      # You can disable this if you're only using the Wayland session.
      enable = true;
      # videoDrivers = ["vmware"]; # is not compatible with m1
      videoDrivers = ["nvidia"]; 
      # Enable touchpad support (enabled default in most desktopManager).
      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;
      # libinput.enable = true;
      xkb = {
        layout = "us";
        variant = "mac";
      };

    };
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


  virtualisation = {

    docker.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
