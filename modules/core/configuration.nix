{ config, lib, pkgs, hostname, ... }:

{
  imports = [
    ./system-packages.nix
    ./ly-colors.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.firewall = {
    checkReversePath = false;
    enable = true;
    allowedUDPPorts = [ 51820 1194 ];
    allowedTCPPorts = [ 443 ];
  };

  networking.hostName = hostname;

  networking.networkmanager.enable = true;
  
  hardware.bluetooth.enable = true;

  time.timeZone = "America/Denver";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  programs.zsh.enable = true;

  programs.dconf.enable = true;

  programs.amnezia-vpn.enable = true;


  programs.steam.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.flatpak.enable = true;

  services.resolved.enable = true;

  services.xserver.enable = true;

  services.displayManager.ly.enable = true;
  #services.displayManager.sddm.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
    };
  };

  users.users.urltanoob = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  fileSystems."/mnt/smb-main" = {
    device = "//10.0.0.212/smb-main";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},username=share,password=4613,uid=1000,gid=100"];
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}

