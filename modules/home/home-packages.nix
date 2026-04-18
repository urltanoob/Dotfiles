{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bibata-cursors
    bluetui
    btop
    claude-code
    cursor-cli
    fastfetch
    firefox
    git
    grim
    hyprlock
    kdePackages.okular
    kitty
    lxappearance
    nerd-fonts.jetbrains-mono
    neovim
    obsidian
    onlyoffice-desktopeditors
    pavucontrol
    playerctl
    proton-vpn
    pywal
    python3
    qbittorrent
    rofi
    slurp
    spotify
    awww
    vlc
    wofi
    wpgtk
    yazi
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    cmatrix
    prismlauncher
    unrar
    qalculate-gtk
    p7zip
    thunar
    wlogout
    rustup
    starship
<<<<<<< Updated upstream
    ckan
    yt-dlp
=======
    wine
>>>>>>> Stashed changes
  ];
}
