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
    netexec
    nikto
    nmap
 
    
    # O
    obsidian
    open-vm-tools
    openvpn
    openssl
    
    opentofu
    
    # P
    proxychains-ng
    platformio
    platformio-core
    vscode-extensions.platformio.platformio-vscode-ide
    pinentry-curses
    
    # R
    ruby
    rbenv
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
    wineWow64Packages.stable
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

    
    #(python3.withPackages (ps: [ps.requests]))
    python3
    #python3Packages.pipx
    #python3Packages.pandas
    #python3Packages.pip
    #python3Packages.numpy
    #python3Packages.requests
    #python3Packages.wcwidth
  ];
}
