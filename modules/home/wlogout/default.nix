{ config, pkgs, ... }:

{
  home.file.".config/wlogout/style.css".source = ./style.css;
}
