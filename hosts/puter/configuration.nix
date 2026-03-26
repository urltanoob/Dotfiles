{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  fileSystems."/mnt/Gamering" = {
    device = "/dev/disk/by-uuid/36AA56A2AA565E85";
    fsType = "ntfs-3g";
    options = [ "uid=1000" "gid=100" "dmask=022" "fmask=133" "exec" "nofail" ];
  };

  fileSystems."/mnt/Less Gamering" = {
    device = "/dev/disk/by-uuid/6E0A20A10A2067F3";
    fsType = "ntfs-3g";
    options = [ "uid=1000" "gid=100" "dmask=022" "fmask=133" "exec" "nofail" ];
  };
}
