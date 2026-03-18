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
      update = "cd ~/nixos-config; cp flake.lock flake.lock.bak; sudo nix flake update; rebuild";
      garbage = "sudo nix-collect-garbage -d; rebuild";
    };

    initContent = ''
      (cat ~/.cache/wal/sequences &)
      source ~/.cache/wal/colors-tty.sh
    '';
  };
}
