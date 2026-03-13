{ ... }:

{
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
