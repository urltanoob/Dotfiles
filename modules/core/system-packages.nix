{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    home-manager
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance
    unzip
    cursor-cli
    rclone
    qbittorrent
    wireguard-tools
    protonvpn-gui
    pavucontrol
    traceroute
    gcc
    kdePackages.okular
    sbctl
    grim
    slurp
  ];
}
