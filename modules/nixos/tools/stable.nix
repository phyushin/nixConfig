{
  lib,
  config,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # A
    android-studio
    android-tools # doesnt work on aarch64
    apktool
    apksigner
    altair
    awscli
    # B
    bat
    # bloodhound
    bluez
    bluez-tools
    brave
    # C
    chromedriver
    
    chromium
    chrony
    cloudlens
    crane
    # D
    dalfox
    dbeaver-bin
    dig
    dirb
    dirbuster
    direnv
    dive
    dnsutils
    docker
    discord
    # E
    efibootmgr
    enum4linux-ng
    exploitdb
    # F
    ffuf
    filezilla
    findomain
    flameshot
    fastfetch
    # G
    gcc
    gdb
    git
    gimp-with-plugins
    go
    gowitness
    # H
    hoppscotch # doesnt work on m1
    hyprland
    # I
    imhex
    inetutils
    inkscape
    # J
    jadx
    jdk11
    jq
    # K
    k9s
    kicad
    kitty
    kubectl
    kubescape
    # L
  
    libgcc
    libimobiledevice
    libxslt
    libreoffice-qt6-fresh
    lon
    # M
    metasploit
    magic-wormhole-rs
    # N
    neo4j
    neovim
    nikto
    nmap
    nodePackages."@angular/cli"
    nodejs_24
    
    # O
    obsidian
    open-vm-tools
    openvpn
    openssl
    opentofu
    
    # P
    platformio
    platformio-core
    vscode-extensions.platformio.platformio-vscode-ide
    
    # R
    ruby
    rgbds
    
    # S
    samdump2
    sameboy
    sbctl
    scrcpy
    signal-desktop
    slack
    spice-vdagent
    spice-gtk
    steam

    # T
    tailscale
    terraform
    tmux
    toybox
    trivy
    # V
    veracrypt
    vivaldi
    vscode-extensions.ms-dotnettools.csdevkit
    vscode-extensions.ms-dotnettools.vscode-dotnet-runtime
    # W
    wget
    whois
    wifite2
    winetricks
    wineWowPackages.stable
    wpscan
    # U
    uv
    # V 
    virt-viewer
    vivaldi
    # Y 
    yarn
    # Z
    zsh

    # python
    (python312.withPackages (ps: [ps.requests]))
    python312
    python312Packages.pipx
    python312Packages.pandas
    python312Packages.pip
    python312Packages.numpy
    python312Packages.requests
    python312Packages.wcwidth
  ];
}
