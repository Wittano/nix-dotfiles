{ config, pkgs, ... }:
let maxJobs = 16;
in {
  nixpkgs.config.allowUnfree = true;
  nix = {
    inherit maxJobs;

    gc.automatic = true;
    autoOptimiseStore = true;
    buildCores = maxJobs;
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
