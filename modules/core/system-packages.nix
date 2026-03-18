{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brightnessctl
    gcc
    glib
    home-manager
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    networkmanager-openvpn
    rclone
    sbctl
    traceroute
    tree
    unzip
    wireguard-tools
  ];
}
