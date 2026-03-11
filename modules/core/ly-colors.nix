{ pkgs, ... }:

{
  systemd.services.pywal-tty = {
    description = "Set pywal colors for TTY";
    wantedBy = [ "multi-user.target" ];
    before = [ "display-manager.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'cat /home/urltanoob/.cache/wal/sequences'";
      StandardOutput = "tty";
      TTYPath = "/dev/tty1";
    };
  };
}
