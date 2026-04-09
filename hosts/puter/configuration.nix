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
}
