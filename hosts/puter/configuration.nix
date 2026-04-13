{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.sessionVariables = {
    RADV_PERFTEST = "gpl";
  };

  fileSystems."/mnt/Gamering" = {
    device = "/dev/disk/by-uuid/36AA56A2AA565E85";
    fsType = "ntfs-3g";
    options = [ "uid=1000" "gid=1000" "dmask=022" "fmask=022" "exec" "nofail" ];
  };

  fileSystems."/mnt/Less Gamering" = {
    device = "/dev/disk/by-uuid/6E0A20A10A2067F3";
    fsType = "ntfs-3g";
    options = [ "uid=1000" "gid=1000" "dmask=022" "fmask=022" "exec" "nofail" ];
  };

  programs.alvr.enable = true;
  programs.alvr.openFirewall = true;

  # SteamVR needs cap_sys_nice on vrcompositor-launcher for real-time scheduling.
  # On NixOS, vrsetup.sh's sudo-based setcap approach doesn't work, so we use a
  # path-activated systemd service that sets the capability once SteamVR is installed.
  systemd.paths.steamvr-vrcompositor-setcap = {
    description = "Watch for SteamVR vrcompositor-launcher to set capabilities";
    wantedBy = [ "paths.target" ];
    pathConfig = {
      PathExists = "/home/urltanoob/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
      Unit = "steamvr-vrcompositor-setcap.service";
    };
  };

  systemd.services.steamvr-vrcompositor-setcap = {
    description = "Set cap_sys_nice on SteamVR vrcompositor-launcher";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.libcap}/bin/setcap cap_sys_nice+ep /home/urltanoob/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
    };
  };
}
