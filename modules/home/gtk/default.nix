{ pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "Graphite-Dark";
      package = pkgs.graphite-gtk-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Graphite-Dark";
      icon-theme = "Papirus-Dark";
      color-scheme = "prefer-dark";
    };
  };
}
