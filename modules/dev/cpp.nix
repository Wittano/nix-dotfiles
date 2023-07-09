{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.dev.clion;
in {
  options = {
    modules.dev.clion = {
      enable = mkEnableOption ''
        Enable cpp development enviroment
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home.packages = with pkgs; [
      cmake
      gcc_multi
      gnumake
      glibc
      jetbrains.clion
    ];
  };
}
