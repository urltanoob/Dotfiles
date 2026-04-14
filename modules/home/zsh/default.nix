{ pkgs, ... }:

{
  home.file.".zshrc".text = ''
    source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  '' + builtins.readFile ./zshrc;
}
