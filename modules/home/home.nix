{ config, pkgs, hostname, ... }:

{
  imports = [
    (../../hosts + "/${hostname}/home.nix")
    ./zsh
    ./kitty
    ./waybar
    ./gtk
    ./nvim
    ./pywal
    ./hyprlock
    ./git
  ];

  
  home.username = "urltanoob";
  home.homeDirectory = "/home/urltanoob";

  home.packages = with pkgs; [
    kitty
    yazi
    wofi
    firefox
    btop
    brightnessctl
    playerctl
    neovim
    git
    zsh
    tree
    swww
    fastfetch
    python3
    bluetui
    spotify
    pywal
    wpgtk
    obsidian
    glib
    kdePackages.dolphin
    onlyoffice-desktopeditors
    nerd-fonts.jetbrains-mono
    vlc
    bibata-cursors
    rofi
    hyprlock
  ];

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
