{ ... }:

{
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
}
