{
  lib,
  config,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # A
    altair
    android-tools
    apktool
    apksigner

    awscli
    # B
    bat
    bloodhound
    bluez
    bluez-tools
    # C
    chromedriver
    chromium
    chrony
    cloudlens
    # D
    dalfox
    dbeaver-bin
    dig
    dirb
    dirbuster
    direnv
    docker
    # E
    enum4linux-ng
    # F
    ffuf
    flameshot

    # G
    gcc
    gdb
    git
    go
    gowitness
    # H
    hyprland
    # I
    imhex
    # J
    jadx
    jdk11
    jq
    # K
    kitty
    k9s
    # L
    libgcc
    libimobiledevice
    libxslt
    libreoffice-qt6-fresh
    # N
    neo4j
    neovim
    nikto
    nmap
    nodejs
    # O
    obsidian
    open-vm-tools
    openvpn
    openssl
    opentofu
    # P
    postman
    # R
    ruby
    rgbds
    # S
    samdump2
    sameboy
    scrcpy
    spice-vdagent
    # T
    terraform
    tmux
    toybox
    # V
    veracrypt
    vscode-extensions.ms-dotnettools.csdevkit
    vscode-extensions.ms-dotnettools.vscode-dotnet-runtime
    # W
    wget
    wifite2
    winetricks
    wineWowPackages.stable
    # U
    uv
    # Z
    zsh

    # python

    python313Packages.pipx
    python313Packages.pandas
    python313Packages.pip
    python313Packages.numpy
    python313Packages.requests
    python313Packages.wcwidth

  ];
}
