{ ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      confirm_os_window_close = 0;
    };
    extraConfig = ''
      include ~/.cache/wal/colors-kitty.conf
    '';
  };
}
