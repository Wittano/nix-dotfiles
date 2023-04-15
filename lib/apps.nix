{ lib, pkgs, dotfiles, home-manager, ... }: {
  importApp = cfg: name:
    import (./../modules/desktop/apps + "/${name}.nix") { inherit cfg pkgs lib dotfiles home-manager; };
}