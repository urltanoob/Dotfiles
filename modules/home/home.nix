{ config, pkgs, hostname, ... }:

{
  imports = [
    (../../hosts + "/${hostname}/home.nix")
    ./home-packages.nix
    ./zsh
    ./kitty
    ./waybar
    ./gtk
    ./nvim
    ./pywal
    ./hyprlock
    ./git
    ./wlogout
    ./cargo
    ./starship
  ];


  home.username = "urltanoob";
  home.homeDirectory = "/home/urltanoob";

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
