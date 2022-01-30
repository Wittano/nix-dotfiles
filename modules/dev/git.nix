{ config, pkgs ? <nixpkgs>, ... }: {
  programs.git = {
    enable = true;
    userName = "Wittano";
    userEmail = "radoslaw.ratyna@gmail.com";
    extraConfig = {
      core.editor = "vim";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
