{ lib, pkgs, dotfiles, home-manager, ownPackages, unstable, ... }: {
  importApp = cfg: name:
    import (./../modules/desktop/apps + "/${name}.nix") { inherit cfg pkgs lib dotfiles home-manager ownPackages unstable; };
}

