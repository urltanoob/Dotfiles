##############################################
# Combined view of all home module configs   #
# This file is for reference only.           #
# Do not import this — use home.nix instead. #
##############################################

{ config, pkgs, hostname, ... }:

{
  imports = [
    (../../hosts + "/${hostname}/home.nix")
  ];

  home.username = "urltanoob";
  home.homeDirectory = "/home/urltanoob";

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  # ── Packages (home-packages.nix) ──────────────────────────────────────

  home.packages = with pkgs; [
    bibata-cursors
    bluetui
    btop
    claude-code
    cursor-cli
    fastfetch
    firefox
    git
    grim
    hyprlock
    kdePackages.dolphin
    kdePackages.okular
    kitty
    lxappearance
    nerd-fonts.jetbrains-mono
    neovim
    obsidian
    onlyoffice-desktopeditors
    pavucontrol
    playerctl
    protonvpn-gui
    pywal
    python3
    qbittorrent
    rofi
    slurp
    spotify
    swww
    vlc
    wofi
    wpgtk
    yazi
    zsh
  ];

  # ── Zsh (zsh/default.nix) ────────────────────────────────────────────

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      v = "nvim";
      sv = "sudo nvim";

      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config";
      update = "sudo nix flake update; rebuild";
      garbage = "sudo nix-collect-garbage -d; rebuild";
      monitors-reload = "systemctl --user restart kanshi.service";
    };

    initContent = ''
      (cat ~/.cache/wal/sequences &)
      source ~/.cache/wal/colors-tty.sh
    '';
  };

  # ── Kitty (kitty/default.nix) ────────────────────────────────────────

  programs.kitty = {
    enable = true;

    settings = {
      confirm_os_window_close = 0;
    };
    extraConfig = ''
      include ~/.cache/wal/colors-kitty.conf
    '';
  };

  # ── Waybar (waybar/default.nix) ──────────────────────────────────────

  programs.waybar = {
    enable = true;

    settings = builtins.fromJSON (builtins.readFile ./waybar/config.jsonc);

    style = builtins.readFile ./waybar/style.css;
  };

  # ── GTK (gtk/default.nix) ────────────────────────────────────────────

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

  # ── Neovim (nvim/default.nix) ────────────────────────────────────────

  home.file.".config/nvim".source = ./nvim/nvim;

  # ── Pywal (pywal/default.nix) ────────────────────────────────────────

  #home.file.".config/wal/templates/colors-wofi.css".source = ./pywal/templates/colors-wofi.css;

  # ── Hyprlock (hyprlock/default.nix) ──────────────────────────────────

  home.file.".config/hypr/hyprlock.conf".source = ./hyprlock/hyprlock.conf;

  # ── Git (git/default.nix) ────────────────────────────────────────────

  programs.git = {
    enable = true;
    settings = {
      user.name = "Jamison";
      user.email = "jBiberdorf937@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };
}
