{ lib, pkgs, dotfiles, home-manager, ... }: {
  getSubModuleConfig = cfg: name:
    import (./../modules/desktop/apps + "/${name}.nix") { inherit cfg pkgs lib dotfiles home-manager; };
}