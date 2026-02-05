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
    crane
    # D
    dalfox
    dbeaver-bin
    dig
    dirb
    dirbuster
    direnv
    dive
    docker
    # E
    enum4linux-ng
    # F
    ffuf
    flameshot
    fastfetch

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
    k9s
    kitty
    kubectl
    kubescape
    # L
    libgcc
    libimobiledevice
    libxslt
    libreoffice-qt6-fresh
    # M
    metasploit
    magic-wormhole-rs
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
    sublist3r
    # T
    terraform
    tmux
    toybox
    trivy
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
    python312
    python312Packages.pipx
    python312Packages.pandas
    python312Packages.pip
    python312Packages.numpy
    python312Packages.requests
    python312Packages.wcwidth

  ];
}
