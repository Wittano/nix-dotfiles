{ config, pkgs, lib, home-manager, unstable, ... }:
with lib;
let cfg = config.modules.dev.python;
in {
  options = {
    modules.dev.python = {
      enable = mkEnableOption ''
        Enable Java development enviroment
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home = {
      packages = with pkgs; [
        virtualenv
        pipenv
        unstable.python3Full
        jetbrains.pycharm-community
      ];
      file.".ideavimrc".text = ''
        set rnu nu
      '';
    };
  };
}
